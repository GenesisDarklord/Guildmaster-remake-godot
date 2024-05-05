extends Control

@onready var TextNode = $text
var text: String
var anteriorText = ""
var textArray = []

func _process(delta):
	mostrarOcultar()
	anterior()
	exec()

func mostrarOcultar():
	if Input.is_action_just_pressed("escape") and visible == true:
		get_tree().paused = false
		visible = false
	if Input.is_action_just_pressed("console"):
		get_tree().paused = true
		visible = true

#-------COMANDOS-----------
func test(text: String):
	print(text)

func nuevaMision():
	get_tree().get_nodes_in_group("Gremio")[0].generarAldeanoConMision()

func nuevoMercenario():
	pass

func pasarDia():
	get_tree().paused = false
	System.pasarDia()

func guardar():
	System.guardarPartida()

func cargar():
	System.cargarPartida()

func cinemaTest():
	get_tree().get_nodes_in_group("cinematica")[0].play("PrimeraAnimacion")

func all_objects():
	for object in System.objetosTotales:
		System.SystemStats.objetosEnAlmacen.append(object.stats.id)
		object.stats.cantidad = 99

func all_misions_timeup():
	for mision in System.misionesTotales:
		mision.stats.diasRestantes = 0

func anterior():
	if Input.is_key_pressed(KEY_UP) and is_visible_in_tree():
		TextNode.text = anteriorText

func exec():
	if Input.is_action_just_pressed("enter") and is_visible_in_tree():
		text = TextNode.text
		anteriorText = TextNode.text
		textArray = text.split(" ")
		if self.has_method(textArray[0]) and textArray.size() > 1:
			call(textArray[0], textArray[0])
		elif self.has_method(TextNode.text):
			call(TextNode.text)
		
		TextNode.text = ""
