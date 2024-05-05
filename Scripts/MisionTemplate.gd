extends TextureButton
var mision

func _ready():
	pass

func mostrarDatos(mision: Mision):
	self.mision = mision
	$nombre_text.text = mision.stats.nombre
	$recompensa_text.text = str(self.mision.stats.drakmar)
	if self.mision.stats.enCurso:
		$enCurso_text.text = "En Curso"
	else:
		$enCurso_text.text = "En Espera"
	
	$diasRestantes.text = str(self.mision.stats.diasRestantes)

func _on_pressed():
	if mision.stats.diasRestantes > 0:
		get_parent().get_parent().get_parent().get_parent().call("mostrarDetallesDeMision", mision)
	else:
		completarMision()

func completarMision():
	var num = randi_range(0, 100)
	if mision.stats.mercenariosAsignados.size() == 4:
		num = 100
	if num > 50:
		System.cumplirMision(mision)
	if num <= 50:
		System.fallarMision(mision)
