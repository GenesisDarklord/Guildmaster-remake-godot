extends TextureRect
var mision: Mision
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func llenarDatos(mision: Mision):
	self.mision = mision
	$nombreLabel.text = mision.stats.nombre
	$drakmar_text.text = str(mision.stats.drakmar)
	$descripcion_text.text = str(mision.stats.descripcion)

func _on_button_pressed():
	System.aceptarMision(mision)
	get_node("/root/Gremio").retirarAldeanoSinMision()
	get_parent().call("cerrarNuevaMisionPanel")

