extends TextureRect

var mercenario: Mercenario

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func llenarDatos(mercenario: Mercenario):
	self.mercenario = mercenario
	$nombre_text.text = mercenario.stats.nombre
	$rango_text.text = str(mercenario.stats.rango)
	$ataque_text.text = str(mercenario.stats.ataque)
	$defensa_text.text = str(mercenario.stats.defensa)

func _on_reclutar_btn_pressed():
	System.reclutarMercenario(mercenario)
	get_parent().call("cerrarNuevoMercenarioPanel")
