extends CanvasLayer

var mision: Mision
var mercenarios = [] #Guarda los templates de los mercenarios con su barra de XP
var mercenarioObj
@onready var objetosContainer = $resultadosMercenarios/objetos
var objetoTemplate = preload("res://Scenes/Menus/resultadosDeMisionObjetoTemplate.tscn")

func _ready():
	pass

func mostrarMisionCumplida(mision: Mision):
	self.mision = mision
	
	mercenarios = get_tree().get_nodes_in_group("resultadosDeMisionMercenarioTemplate")
	for mercenario in mercenarios:
		mercenario.visible = false
		mercenario.reset()
	
	var i = 0
	for mercenarioID in mision.stats.mercenariosAsignados:
		mercenarioObj = System.buscarMercenarioPorId(mercenarioID)
		mercenarios[i].cargar(mercenarioObj, mision.stats.XP)
		mercenarios[i].visible = true
		i += 1
	
	configurarObjetosObtenidos()
	
	$animaciones.play("popUp")

func mostrarMisionFallida():
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
