extends TextureRect

var objeto: Objeto
@onready var imageObject:Sprite2D = $sprite/imageObject
@onready var imageEquipment:Sprite2D = $sprite/imageEquipment
@onready var cant: Label = $cant_label


func configure(objeto, cantidad):
	cant.text = str(cantidad)
	
	if objeto.stats.tipo == "Material":
		imageObject.visible = true
		imageEquipment.visible = false
		imageObject.frame_coords = objeto.stats.coords
	else:
		imageObject.visible = false
		imageEquipment.visible = true
		imageEquipment.frame_coords = objeto.stats.coords
