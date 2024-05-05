extends TextureRect

signal objeto_presionado(objeto: Objeto)
var objeto: Objeto
@onready var imageObject = $sprite/imageObject
@onready var imageEquipment = $sprite/imageEquipment
@onready var precio = $precio

func configure(objeto: Objeto):
	self.objeto = objeto
	
	if objeto.stats.tipo == "Material":
		imageObject.visible = true
		imageEquipment.visible = false
		imageObject.frame_coords = objeto.stats.coords
	else:
		imageEquipment.visible = true
		imageObject.visible = false
		imageEquipment.frame_coords = objeto.stats.coords
	
	precio.text = str(objeto.stats.precio)

func objetoPresionado():
	emit_signal("objeto_presionado", objeto)
