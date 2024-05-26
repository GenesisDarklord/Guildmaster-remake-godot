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
	$clase_text.text = mercenario.stats.clase
	
	actualizarStats()

func actualizarStats():
	var fuerza = mercenario.stats.fuerza
	var destreza = mercenario.stats.destreza
	var sabiduria = mercenario.stats.sabiduria
	var containerFuerza = $fuerzaContainer
	var containerDestreza = $destrezaContainer
	var containerSabiduria = $sabiduriaContainer
	var indicadorFuerza = $fuerzaContainer/fuerza_indicador
	var indicadroDestreza = $destrezaContainer/destreza_indicador
	var indicadorSabiduria = $sabiduriaContainer/sabiduria_indicador
	
	actualizarIndicador(indicadorFuerza, fuerza, containerFuerza)
	actualizarIndicador(indicadroDestreza, destreza, containerDestreza)
	actualizarIndicador(indicadorSabiduria, sabiduria, containerSabiduria)

func actualizarIndicador(indicador: TextureRect, stat, container:HBoxContainer):
	var cantidad = int(stat / 20)
	
	for i in range(cantidad):
		var instance = indicador.duplicate()
		instance.visible = true
		container.add_child(instance)

func _on_reclutar_btn_pressed():
	System.reclutarMercenario(mercenario)
	get_parent().call("cerrarNuevoMercenarioPanel")
