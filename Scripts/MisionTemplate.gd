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
	var sumaStats = 0
	
	for mercenarioID in mision.stats.mercenriosAsignados:
		sumaStats += System.buscarMercenarioPorId(mercenarioID).stats.ataque
	
	var num = randi_range(0, 100)
	var XP = mision.stats.XP
	var div = float(sumaStats) / float(XP)
	var porciento = int(div * 100)
	
	if num < porciento:
		System.cumplirMision(mision)
	if num > porciento:
		System.fallarMision(mision)
