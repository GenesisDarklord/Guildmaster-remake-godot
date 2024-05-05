extends Control

var recetas = []
var recetaSeleccionada = null
var crafteable: bool = true

func abrirMejorasPanel():
	Flags.mejorando = true
	get_tree().get_nodes_in_group("panelesActivos")[0].call("cerrarPaneles")
	self.visible = true
	$craftPanel_bg.visible = false
	actualizarMaximos()

func cerrarMejorasPanel():
	$craftPanel_bg.visible = false
	Flags.mejorando = false
	self.visible = false

func actualizarReceta(mejora: Mejora):
	var receta = mejora
	recetaSeleccionada = receta
	crafteable = true
	$craftPanel_bg.visible = true
	
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
	pass

func aplicarMejora():
	var mejora = recetaSeleccionada
	var gremio = get_tree().get_nodes_in_group('Gremio')[0]
	
	if crafteable:
		var material1 = System.buscarObjetoPorId(mejora.material1.stats.id)
		var material2 = System.buscarObjetoPorId(mejora.material2.stats.id)
		var material3 = System.buscarObjetoPorId(mejora.material3.stats.id)
		material1.stats.cantidad -= mejora.cantMaterial1
		material2.stats.cantidad -= mejora.cantMaterial2
		material3.stats.cantidad -= mejora.cantMaterial3
	
		if mejora.tipo == 'mercenarios':
			gremio.stats.maxCantMercenarios += 5
		if mejora.tipo == 'misiones':
			gremio.stats.maxCantMisiones += 2
		if mejora.tipo == 'drakmar':
			gremio.stats.max_drakmar += 1000
		
		actualizarReceta(mejora)
	
	actualizarMaximos()

func actualizarMaximos():
	var gremio = get_tree().get_nodes_in_group('Gremio')[0]
	$panelBase/mejoraDrakmar/cantidad_label.text = 'Max: ' + str(gremio.stats.max_drakmar)
	$panelBase/mejoraMercenarios/cantidad_label.text = 'Max: ' + str(gremio.stats.maxCantMercenarios)
	$panelBase/mejoraMisiones/cantidad_label.text = 'Max: ' + str(gremio.stats.maxCantMisiones)

class Mejora:
	var ID: int
	var material1: Objeto
	var cantMaterial1: int
	var material2: Objeto
	var cantMaterial2: int
	var material3: Objeto
	var cantMaterial3: int
	var tipo: String
	
	func _init(ID, material1, cantMaterial1, material2, cantMaterial2, material3, cantidadMaterial3, tipo):
		self.ID = ID
		self.material1 = material1
		self.cantMaterial1 = cantMaterial1
		self.material2 = material2
		self.cantMaterial2 = cantMaterial2
		self.material3 = material3
		self.cantMaterial3 = cantMaterial3
		self.tipo = tipo

func mostrarMejoraMercenarios():
	var mejora = Mejora.new(
		1,
		System.buscarObjetoPorNombre('Madera'),
		20,
		System.buscarObjetoPorNombre('Roca'),
		20,
		System.buscarObjetoPorNombre('Lingote de hierro'),
		10,
		'mercenarios'
	)
	mejora.cantMaterial3 = 10
	actualizarReceta(mejora)
	pass # Replace with function body.

func mostrarMejoraMisiones():
	var mejora = Mejora.new(
		1,
		System.buscarObjetoPorNombre('Tablon Madera'),
		20,
		System.buscarObjetoPorNombre('Bloque de piedra'),
		20,
		System.buscarObjetoPorNombre('Lingote de hierro'),
		10,
		'misiones'
	)
	mejora.cantMaterial3 = 10
	actualizarReceta(mejora)
	pass # Replace with function body.

func mostrarMejoraDrakmar():
	var mejora = Mejora.new(
		1,
		System.buscarObjetoPorNombre('Madera'),
		10,
		System.buscarObjetoPorNombre('Roca'),
		10,
		System.buscarObjetoPorNombre('Mena de hierro'),
		5,
		'mercenarios'
	)
	mejora.cantMaterial3 = 5
	actualizarReceta(mejora)
	pass # Replace with function body.
