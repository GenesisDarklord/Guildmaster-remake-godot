extends Control

@onready var objetoTienda := $objetoTienda
@onready var container := $background/ScrollContainer/GridContainer

func _ready():
	self.visible = false

func comprarObjeto(objeto):
	if get_tree().get_first_node_in_group("Gremio").stats.drakmar >= objeto.stats.precio:
		objeto.stats.cantidad += 1
		get_tree().get_nodes_in_group("Gremio")[0].stats.drakmar -= objeto.stats.precio

func abirMercaderPanel():
	get_tree().get_nodes_in_group("panelesActivos")[0].cerrarPaneles()
	llenarTienda()
	self.visible = true

func cerrarMercaderPanel():
	self.visible = false
	limpiarTienda()

func limpiarTienda():
	for item in container.get_children():
		item.queue_free()

func llenarTienda():
	for item in System.objetosTotales:
		if item.stats.obtenibleDeMercader:
			var stock = objetoTienda.duplicate()
			container.add_child(stock)
			stock.configure(item)
			stock.visible = true
