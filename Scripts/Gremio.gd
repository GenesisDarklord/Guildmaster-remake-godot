extends Node2D

@export var stats = {
	"drakmar": 1000,
	"max_drakmar": 2000,
	"cantMisionesAceptadas": 0,
	"maxCantMisiones": 5,
	"cantMercenariosDisponibles": 0,
	"cantMercenariosEnMision": 0,
	"maxCantMercenarios":10,
	"prestigio": 0,
	"salarioPorMercenario": 100
}

@onready var npcsNode = $Environment/NPCS
@onready var pathsNode: Paths = $Environment/Paths

var isInGuild:bool = false # determina si se esta dentro o fuera del gremio

func _ready() -> void:
	System.cargarMisiones()
	System.organizarMisiones()
	System.cargarObjetos()
	get_tree().set_current_scene(self)

func _process(delta):
	actualizarInfo()
	actualizarInfoGeneral()

func actualizarInfo():
	stats.cantMisionesAceptadas = System.SystemStats.misionesAceptadas.size()
	stats.cantMercenariosEnMision = System.SystemStats.mercenariosEnMision.size()
	stats.cantMercenariosDisponibles = System.SystemStats.mercenariosContratados.size() - stats.cantMercenariosEnMision

func actualizarInfoGeneral():
	$GUI/Infos/InfoGeneral/cantMercenariosDisponibles_label.text = str(stats.cantMercenariosDisponibles)
	$GUI/Infos/InfoGeneral/cantMercenariosEnMision_label.text = str(stats.cantMercenariosEnMision)
	$GUI/Infos/InfoGeneral/cantMisiones_label.text = str(stats.cantMisionesAceptadas)
	$GUI/Infos/InfoGeneral/drakmar_label.text = str(stats.drakmar)
	$GUI/Infos/InfoGeneral/prestigio_label.text = str(stats.prestigio)
	
	if GlobalTime.TIME.minutos == 0:
		$GUI/Infos/InfoGeneral/hora_minutos_label.text = str(GlobalTime.TIME.hora) + ":" + "00"
	else:
		$GUI/Infos/InfoGeneral/hora_minutos_label.text = str(GlobalTime.TIME.hora) + ":" + str(GlobalTime.TIME.minutos)
	#$GUI/Infos/InfoGeneral/drakmar_label.text = "234"
	$GUI/Infos/InfoGeneral/dia_mes_label.text = str(GlobalTime.TIME.dia) + "/" + str(GlobalTime.TIME.mes)

func getStats(): #Para conseguir un diccionario con los datos del gremio para guardarlos
	return stats

func setStats(data: Dictionary):#Para escribir los datos del gremio desde un diccionario
	stats = data

func _on_salir_btn_pressed() -> void:
	pass

func _on_reanudar_btn_pressed() -> void:
	pass # Replace with function body.

func _on_opciones_btn_pressed() -> void:
	pass # Replace with function body.

func _on_menuPrincipal_btn_pressed() -> void:
	get_tree().paused = false
	System.guardarPartida()
	System.call_deferred("changeScene", "res://Scenes/Pantallas/MenuPrincipal.tscn")

func pasarDia():
	System.pasarDia()
	elegirClima()

func encenderFaroles():
	var faroles  = get_tree().get_nodes_in_group("lampara")
	for farol in faroles:
		farol.encender()

func apagarFaroles():
	var faroles  = get_tree().get_nodes_in_group("lampara")
	for farol in faroles:
		farol.apagar()

func generarAldeanoConMision(): #genera un aldeano que caminara hacia el mostrador con la mision
	if !pathsNode.recibiendoMision:
		var mision = System.nuevaMision()
		var aldeano = ResourceLoader.load("res://Scenes/aldeano.tscn")
		var aldeanoInstance = aldeano.instantiate()
		npcsNode.add_child(aldeanoInstance)
		aldeanoInstance.mision = mision #se le pasa la mision al aldeano
		pathsNode.aldeanoConMision(mision, aldeanoInstance)

func retirarAldeanoSinMision():
	var aldeanos = get_tree().get_nodes_in_group("aldeano")
	for aldeano in aldeanos:
		if aldeano.mision != null:
			pathsNode.aldeanoSinMision(aldeano)

func entrarGremio():
	if !isInGuild:
		isInGuild = true
		var mainCamera:Camera2D = $MainCamera
		var tween = get_tree().create_tween()
		var zoomTween = get_tree().create_tween()
		var distancia = calcularHipotenusa(mainCamera.position,Vector2(-451,344))
		tween.tween_property(mainCamera,"position",Vector2(-451,344), distancia/2000)
		zoomTween.tween_property(mainCamera,"zoom",Vector2(1,1), (1 - mainCamera.zoom.x) * 2)
		await tween.finished
		$Animations.play("entrarGremio")

func salirGremio():
	if isInGuild:
		isInGuild = false
		$Animations.play("salirGremio")

func calcularHipotenusa(v1:Vector2, v2:Vector2):
	var h
	var v3 = v1 - v2
	h = sqrt(pow(v3.x,2) + pow(v3.y,2))#se halla la hipotenusa
	return h

func _on_global_time_timeout():
	GlobalTime.TIME.minutos += 10
	comprobarSueldoMercenarios()
	comprobarAburrimiento()
	mostrarTutoriales()
	comprobarMisionesTerminadas()

func comprobarMisionesTerminadas():
	var hora = GlobalTime.TIME.hora
	var minutos = GlobalTime.TIME.minutos
	
	var misionesTerminadas = []
	
	if hora == 6 and minutos == 20:
		for misionID in System.SystemStats.misionesEnCurso:
			if System.buscarMisionPorId(misionID).stats.diasRestantes == 0:
				misionesTerminadas.append(misionID)
	
	procesarColaMisionesCompletadas(misionesTerminadas)

func procesarColaMisionesCompletadas(cola: Array):
	while cola.size() != 0:
		var misionID = cola.pop_front()
		completarMision(System.buscarMisionPorId(misionID))
		await $resultadosDeMision.terminado

func completarMision(mision: Mision):
	var sumaStats = 0
	
	for mercenarioID in mision.stats.mercenariosAsignados:
		sumaStats += System.buscarMercenarioPorId(mercenarioID).stats.ataque
	
	var num = randi_range(0, 100)
	var XP = mision.stats.XP
	var div = float(sumaStats) / float(XP)
	var porciento = int(div * 100)
	
	if num < porciento:
		System.cumplirMision(mision)
	if num > porciento:
		System.fallarMision(mision)

func comprobarSueldoMercenarios():
	var dia = GlobalTime.TIME.dia
	var hora = GlobalTime.TIME.hora
	var minutos = GlobalTime.TIME.minutos
	var cantidadMercenarios = System.SystemStats.mercenariosContratados.size()
	
	if cantidadMercenarios != 0:
		var salario_total = cantidadMercenarios * stats.salarioPorMercenario
	
		if dia % 7 == 0 and hora == 10 and minutos == 10:
			if stats.drakmar >= salario_total:
				stats.drakmar -= salario_total
				System.mostrarPopUp('Se le ha pagado el salario a cada uno de los mercenarios\n Salario total pagado: ' + str(salario_total))
			else:
				System.retirarMercenarioAleatorio()

func comprobarAburrimiento():
	var dia = GlobalTime.TIME.dia
	var hora = GlobalTime.TIME.hora
	var minutos = GlobalTime.TIME.minutos
	
	if hora == 12 and minutos == 10:
		for mercenario in System.SystemStats.mercenariosContratados:
			if mercenario.stats.enMision == false:
				mercenario.stats.aburrimiento -= 1
		
		for mercenario in System.SystemStats.mercenariosContratados:
			if mercenario.stats.aburrimiento <= 0:
				System.retirarMercenarioAburrido(mercenario.stats.id)
				break

func mostrarTutoriales():
	var hora = GlobalTime.TIME.hora
	var minutos = GlobalTime.TIME.minutos
	
	if hora == 7 and minutos == 10 and Flags.FLAGS.NuevaPartida:
		$GUI.abrir_tutoriales()
		Flags.FLAGS.NuevaPartida = false

func _on_transeunte_generator_timer_timeout():
	var aldeanoTranseunte = ResourceLoader.load("res://Scenes/aldeano.tscn")
	var aldeanoInstance = aldeanoTranseunte.instantiate()
	npcsNode.add_child(aldeanoInstance)
	pathsNode.nuevoTranseunte(aldeanoInstance)

func _on_mercenario_generator_timer_timeout():
	if pathsNode.getAvailableMercenaryPaths().size() != 0:
		var mercenarioResource = ResourceLoader.load("res://Scenes/mercenary.tscn")
		var mercenarioInstance: mercenary = mercenarioResource.instantiate()
		var mercenario: Mercenario = System.generarMercenarioNuevo()
		npcsNode.add_child(mercenarioInstance)
		pathsNode.nuevoMercenario(mercenario, mercenarioInstance)

func toMenuPrincipal():
	System.guardarPartida()
	get_tree().paused = false
	System.changeScene("res://Scenes/Pantallas/MenuPrincipal.tscn")

func _on_auto_save_timer_timeout():
	System.guardarPartida()

func _on_nueva_mision_timer_timeout():
	generarAldeanoConMision()

func elegirClima():
	var climas = [
		'sol',
		'lluvia',
		'niebla'
	]
	
	var clima = climas[randi_range(0, 2)]
	
	if clima == 'sol':
		$rain.visible = false
		$niebla_sprite.visible = false
	elif clima == 'lluvia':
		$rain.visible = true
		$niebla_sprite.visible = false
	elif clima == 'niebla':
		$rain.visible = false
		$niebla_sprite.visible = true

func mostrarPopUp(texto:String):
	var canvas = $PopUps
	var popUpText = $PopUps/pop_up_bg/RichTextLabel
	
	popUpText.text = texto
	canvas.visible = true
	get_tree().paused = true
	
	pass

func cerrarPopUp():
	var canvas = $PopUps
	
	canvas.visible = false
	get_tree().paused = false
