extends CanvasLayer

var mision: Mision
var mercenarios = [] #Guarda los templates de los mercenarios con su barra de XP
var mercenarioObj
@onready var objetosContainer = $resultadosMercenarios/objetos
var objetoTemplate = preload("res://Scenes/Menus/resultadosDeMisionObjetoTemplate.tscn")
signal terminado


func _ready():
	pass

func limpiarObjetosObtenidos():
	for child in objetosContainer.get_children():
		child.queue_free()

func mostrarMisionCumplida(mision: Mision):
	limpiarObjetosObtenidos()
	
	$resultadosMercenarios/nombre_mision.text = mision.stats.nombre
	
	self.mision = mision
	var gremio_instance = get_tree().get_nodes_in_group('Gremio')[0]
	
	mercenarios = get_tree().get_nodes_in_group("resultadosDeMisionMercenarioTemplate")
	for mercenario in mercenarios:
		mercenario.visible = false
		mercenario.reset()
	
	gremio_instance.stats.prestigio += mision.stats.prestigio
	gremio_instance.stats.drakmar += mision.stats.drakmar
	
	var i = 0
	for mercenarioID in mision.stats.mercenariosAsignados:
		mercenarioObj = System.buscarMercenarioPorId(mercenarioID)
		mercenarios[i].cargar(mercenarioObj, mision.stats.XP)
		mercenarios[i].visible = true
		i += 1
	
	configurarObjetosObtenidos()
	
	$animaciones.play("popUp")

func mostrarMisionFallida(mision: Mision):
	$resultadosMercenarios/nombre_mision.text = mision.stats.nombre
	$animaciones.play("misionFallida")

func configurarObjetosObtenidos():
	if mision.stats.recompensa != null:
		var nombresDeItems = mision.stats.recompensa
		var listadoDeObjetos = []
		
		for nombre in nombresDeItems:
			listadoDeObjetos.append(System.buscarObjetoPorNombre(nombre))
		
		for objeto in listadoDeObjetos:
			var cantidad = randi_range(1,3)
			var objetoInstance = objetoTemplate.instantiate()
			objetosContainer.add_child(objetoInstance)
			objetoInstance.configure(objeto, cantidad)
			System.adquirirObjeto(objeto, cantidad)

func _on_boton_pressed():
	for mercenario in mercenarios:
		mercenario.reset()
	
	$background.visible = false
	$boton.visible = false
	$resultadosMercenarios.visible = false
	$mercenarios.visible = false
	
	emit_signal("terminado")
