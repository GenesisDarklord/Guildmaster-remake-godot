extends Control

var objeto: Objeto
@export var imageObject: Sprite2D
@export var imageEquipment: Sprite2D
@export var nombre: Label
@export var descripcion: RichTextLabel

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
	
	descripcion.text = objeto.stats.descripcion
	nombre.text = objeto.stats.nombre
