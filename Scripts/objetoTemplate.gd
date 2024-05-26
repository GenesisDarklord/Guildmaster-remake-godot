class_name ObjetoTemplate
extends TextureButton

signal objetoPresionado
var objeto: Objeto
@export var imageObject: Sprite2D
@export var imageEquipment: Sprite2D
@export var cantidad: Label
@export var nombre: Label

func _on_pressed():
	if Flags.vendiendo:
		vender()
	else:
		emit_signal("objetoPresionado", objeto)

func vender():
	var gremio_instance = get_tree().get_nodes_in_group('Gremio')[0]
	
	if objeto.stats.cantidad > 0:
		gremio_instance.stats.drakmar += objeto.stats.valor
		objeto.stats.cantidad -= 1
		updateData()

func configure(objeto: Objeto):
	self.objeto = objeto
	
	if objeto.stats.tipo == "Material":
		imageObject.visible = true
		imageEquipment.visible = false
		imageObject.frame_coords = objeto.stats.coords
	else: 
		imageObject.visible = false
		imageEquipment.visible = true
		imageEquipment.frame_coords = objeto.stats.coords
	
	updateData()
	nombre.text = objeto.stats.nombre

func updateData():
	cantidad.text = "Cant: " + str(objeto.stats.cantidad)






