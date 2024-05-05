extends Control

@export var almacen: AlmacenarPanel
@onready var container = $almacenPanel/ScrollContainer/VBoxContainer
var recetas = []
var recetaSeleccionada: Receta = null
var crafteable: bool = true

func abrirHerreriaPanel():
	Flags.crafteando = true
	get_tree().get_nodes_in_group("panelesActivos")[0].call("cerrarPaneles")
	llenarRecetas()
	self.visible = true
	almacen.call("listAllObjects")
	almacen.call("filtrarCrafteables")

func cerrarHerreriaPanel():
	$craftPanel_bg.visible = false
	self.visible = false
	Flags.crafteando = false
	for child in container.get_children():
		child.queue_free()

func llenarRecetas():
	for objeto in System.objetosTotales:
		if objeto.stats.tiempoFabricacion > 0:
			recetas.append(Receta.new(
				objeto.stats.id,
				System.buscarObjetoPorNombre(objeto.stats.material_1),
				objeto.stats.cantMaterial_1,
				System.buscarObjetoPorNombre(objeto.stats.material_2),
				objeto.stats.cantMaterial_2,
				System.buscarObjetoPorNombre(objeto.stats.material_3),
				objeto.stats.cantMaterial_3,
				objeto
			))

func recetaPresionada(objeto):
	var receta = buscarRecetaPorID(objeto.stats.id)
	recetaSeleccionada = receta
	crafteable = true
	prepararCantMateriales(receta)
	
	if receta.material1 != null:
		$craftPanel_bg/material1/sprite/imageObject.frame_coords = receta.material1.stats.coords
		$craftPanel_bg/material1/cant_label.text = str(receta.cantMaterial1) + "/" + str(receta.material1.stats.cantidad)
		if receta.material1.stats.cantidad < receta.cantMaterial1:
			crafteable = false
			$craftPanel_bg/material1/cant_label.add_theme_color_override("font_color",Color.RED)
		else:
			$craftPanel_bg/material1/cant_label.add_theme_color_override("font_color",Color.BLACK)
	if receta.material2 != null:
		$craftPanel_bg/material2/sprite/imageObject.frame_coords = receta.material2.stats.coords
		$craftPanel_bg/material2/cant_label.text = str(receta.cantMaterial2) + "/" + str(receta.material2.stats.cantidad)
		if receta.material2.stats.cantidad < receta.cantMaterial2:
			crafteable = false
			$craftPanel_bg/material2/cant_label.add_theme_color_override("font_color",Color.RED)
		else:
			$craftPanel_bg/material2/cant_label.add_theme_color_override("font_color",Color.BLACK)
	if receta.material3 != null:
		$craftPanel_bg/material3/sprite/imageObject.frame_coords = receta.material3.stats.coords
		$craftPanel_bg/material3/cant_label.text = str(receta.cantMaterial3) + "/" + str(receta.material3.stats.cantidad)
		if receta.material3.stats.cantidad < receta.cantMaterial3:
			crafteable = false
			$craftPanel_bg/material3/cant_label.add_theme_color_override("font_color",Color.RED)
		else:
			$craftPanel_bg/material3/cant_label.add_theme_color_override("font_color",Color.BLACK)
	
	if receta.resultado.stats.tipo == "Material":
		$craftPanel_bg/resultado/sprite/imageObject.visible = true
		$craftPanel_bg/resultado/sprite/imageEquipment.visible = false
		$craftPanel_bg/resultado/sprite/imageObject.frame_coords = receta.resultado.stats.coords
	else:
		$craftPanel_bg/resultado/sprite/imageEquipment.visible = true
		$craftPanel_bg/resultado/sprite/imageObject.visible = false
		$craftPanel_bg/resultado/sprite/imageEquipment.frame_coords = receta.resultado.stats.coords
	
	$craftPanel_bg.visible = true

func craftearItem():
	if crafteable:
		recetaSeleccionada.material1.stats.cantidad -= recetaSeleccionada.cantMaterial1
		if recetaSeleccionada.material2 != null:
			recetaSeleccionada.material2.stats.cantidad -= recetaSeleccionada.cantMaterial2
		if recetaSeleccionada.material3 != null:
			recetaSeleccionada.material3.stats.cantidad -= recetaSeleccionada.cantMaterial3
		recetaSeleccionada.resultado.stats.cantidad += 1
		recetaPresionada(recetaSeleccionada.resultado)
	almacen.updateData()

func prepararCantMateriales(receta):
	$craftPanel_bg/material1.visible = true if receta.material1 != null else false
	$craftPanel_bg/material2.visible = true if receta.material2 != null else false
	$craftPanel_bg/material3.visible = true if receta.material3 != null else false

func buscarRecetaPorID(ID):
	for receta in recetas:
		if receta.ID == ID:
			return receta
	return null

class Receta:
	var ID: int
	var material1: Objeto
	var cantMaterial1: int
	var material2: Objeto
	var cantMaterial2: int
	var material3: Objeto
	var cantMaterial3: int
	var resultado: Objeto
	
	func _init(ID, material1, cantMaterial1, material2, cantMaterial2, material3, cantidadMaterial3, resultado):
		self.ID = ID
		self.material1 = material1
		self.cantMaterial1 = cantMaterial1
		self.material2 = material2
		self.cantMaterial2 = cantMaterial2
		self.material3 = material3
		self.cantMaterial3 = cantMaterial3
		self.resultado = resultado
