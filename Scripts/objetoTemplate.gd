class_name ObjetoTemplate
extends TextureButton

signal objetoPresionado
var objeto: Objeto
@export var imageObject: Sprite2D
@export var imageEquipment: Sprite2D
@export var cantidad: Label
@export var nombre: Label

func _on_pressed():
	emit_signal("objetoPresionado", objeto)


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






