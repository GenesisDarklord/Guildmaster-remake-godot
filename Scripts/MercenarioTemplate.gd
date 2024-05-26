extends Control

var mercenario: Mercenario

func _on_pressed():
	if Flags.preparandoMision:
		get_parent().get_parent().get_parent().get_parent().get_node("detallesMisionPanel").call("agregarMercenario", mercenario)
		get_parent().get_parent().get_parent().get_parent().call("ActualizarAnguloBalanza")
	else:
		get_parent().get_parent().get_parent().get_parent().call("mostrarDetallesMercenarioPanel", mercenario)
		get_parent().get_parent().get_parent().get_parent().call("cerrarAlmacenPanel")
		Flags.equipandoMercenario = false
		Flags.equipandoMercenarioArma = false
		Flags.equipandoMercenarioArmadura = false

func mostrarDatos(mercenario:Mercenario):
	self.mercenario = mercenario
	
	if mercenario.stats.enMision:
		self.modulate = Color.SLATE_GRAY
	
	$Nombre_text.text = mercenario.stats.nombre
	$rango_text.text = "Rank: " + str(mercenario.stats.rango)
	$mercenario_icon.texture = ResourceLoader.load(mercenario.stats.retrato)
