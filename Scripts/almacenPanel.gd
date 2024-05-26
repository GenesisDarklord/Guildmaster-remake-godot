class_name AlmacenarPanel
extends TextureRect

signal recetaPresionada(objeto: Objeto)
@onready var container: VBoxContainer = $ScrollContainer/VBoxContainer
var objetoScene = preload("res://Scenes/Menus/objetoTemplate.tscn")

func _ready():
	pass

func list_objects():
#	if System.SystemStats.objetosEnAlmacen.size() > 0:
#		for objectID in System.SystemStats.objetosEnAlmacen:
	limpiarLista()
	for objeto in System.objetosTotales:
		if objeto.stats.cantidad > 0:
			var objetoInstance: ObjetoTemplate = objetoScene.instantiate()
			objetoInstance.configure(objeto)
			container.add_child(objetoInstance)
			if Flags.crafteando:
				objetoInstance.objetoPresionado.connect(emitirReceta)
			else:
				objetoInstance.objetoPresionado.connect(mostrarDetalles)

func limpiarLista():
	container = $ScrollContainer/VBoxContainer
	for item in container.get_children():
		item.queue_free()

func listAllObjects():
	for objeto in System.objetosTotales:
		var objetoInstance: ObjetoTemplate = objetoScene.instantiate()
		objetoInstance.configure(objeto)
		container.add_child(objetoInstance)
		if Flags.crafteando:
			objetoInstance.objetoPresionado.connect(emitirReceta)
		else:
			objetoInstance.objetoPresionado.connect(mostrarDetalles)

func updateData():
	var list = container.get_children()
	
	for element in list:
		element.updateData()

func emitirReceta(objeto):
	emit_signal("recetaPresionada", objeto)

func mostrarDetalles(objeto):
	if Flags.equipandoMercenario:
		get_tree().get_nodes_in_group("detallesMercenarioPanel")[0].call_deferred("agregarEquipamiento", objeto)
	else:
		get_tree().get_nodes_in_group("panelesActivos")[0].call("mostrarDetallesObjetoPanel", objeto)

func filtrarArmas():
	list_objects()
	
	var list = container.get_children()
	for element in list:
		if element.objeto.stats.tipo != "Arma":
			element.visible = false
		else:
			element.visible = true

func filtrarArmaduras():
	list_objects()
	
	var list = container.get_children()
	for element in list:
		if element.objeto.stats.tipo != "Armadura":
			element.visible = false
		else:
			element.visible = true

func filtrarCrafteables():
	var list = container.get_children()
	
	for element in list:
		if element.objeto.stats.tiempoFabricacion > 0:
			element.visible = true
		else:
			element.visible = false
	
	
	
	
	
	
