extends TextureRect

var mision: Mision
var emptyPortrait = preload("res://Sprites/EmptyPortrait.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if mision != null and mision.stats.enCurso:
		$enviar_btn.visible = false
		$iniciarMision_btn.visible = false
	else:
		if Flags.preparandoMision:
			$enviar_btn.set("visible", true)
			$iniciarMision_btn.set("visible", false)
		else:
			$enviar_btn.set("visible", false)
			$iniciarMision_btn.set("visible", true)

func llenarDatos(mision: Mision):
	self.mision = mision
	$nombre_text.text = mision.stats.nombre
	$drakmar_text.text = str(mision.stats.drakmar)
	$descripcion_text.text = str(mision.stats.descripcion)
	
	if System.SystemStats.misionesEnCurso.find(mision.stats.id) != -1:
		$enviar_btn.set("visible", false)
		$iniciarMision_btn.set("visible", false)
	else:
		$iniciarMision_btn.set("visible", true)
	actualizarProtraits()

func _on_iniciar_mision_btn_pressed():
	get_parent().call("iniciarMision", mision)
#	$iniciarMision_btn.set("visible", false)
#	$enviar_btn.visible = true

func _on_enviar_btn_pressed():
	if mision.stats.mercenariosAsignados.size() > 0:
		System.iniciarMision(mision)
		Flags.preparandoMision = false
		get_parent().call("ComenzarMision")

func agregarMercenario(mercenario: Mercenario):
	if System.SystemStats.mercenariosEnMision.find(mercenario.stats.id) == -1:
		if mision.stats.mercenariosAsignados.size() < 4 and mision.stats.mercenariosAsignados.find(mercenario.stats.id) == -1:
			mision.stats.mercenariosAsignados.append(mercenario.stats.id)
		actualizarProtraits()

func LimpiarMercenariosAsignados():
	mision.stats.mercenariosAsignados = []

func actualizarProtraits():
	var button: TextureButton
	var i = 0
	
	$portraits/mercenario0_btn.texture_normal = null
	$portraits/mercenario1_btn.texture_normal = null
	$portraits/mercenario2_btn.texture_normal = null
	$portraits/mercenario3_btn.texture_normal = null
	
	for mercenarioID in mision.stats.mercenariosAsignados:
		var mercenario = System.buscarMercenarioPorId(mercenarioID)
		var retratoRES = ResourceLoader.load(mercenario.stats.retrato)
		button = get_node("portraits/mercenario"+str(i)+"_btn")
		button.texture_normal = retratoRES
		i+=1
		
	if Flags.preparandoMision:
		get_parent().call("ActualizarAnguloBalanza")

func _on_mercenario_0_btn_pressed():
	if Flags.preparandoMision:
		mision.stats.mercenariosAsignados.remove_at(0)
		actualizarProtraits()
	elif mision.stats.mercenariosAsignados.size() >= 1:
		get_tree().get_nodes_in_group("panelesActivos")[0].call("mostrarDetallesMercenarioPanel",System.buscarMercenarioPorId(mision.stats.mercenariosAsignados[0]))

func _on_mercenario_1_btn_pressed():
	if Flags.preparandoMision:
		mision.stats.mercenariosAsignados.remove_at(1)
		actualizarProtraits()
	elif mision.stats.mercenariosAsignados.size() >= 2:
		get_tree().get_nodes_in_group("panelesActivos")[0].call("mostrarDetallesMercenarioPanel",System.buscarMercenarioPorId(mision.stats.mercenariosAsignados[1]))

func _on_mercenario_2_btn_pressed():
	if Flags.preparandoMision:
		mision.stats.mercenariosAsignados.remove_at(2)
		actualizarProtraits()
	elif mision.stats.mercenariosAsignados.size() >= 3:
		get_tree().get_nodes_in_group("panelesActivos")[0].call("mostrarDetallesMercenarioPanel",System.buscarMercenarioPorId(mision.stats.mercenariosAsignados[2]))

func _on_mercenario_3_btn_pressed():
	if Flags.preparandoMision:
		mision.stats.mercenariosAsignados.remove_at(3)
		actualizarProtraits()
	elif mision.stats.mercenariosAsignados.size() == 4:
		get_tree().get_nodes_in_group("panelesActivos")[0].call("mostrarDetallesMercenarioPanel",System.buscarMercenarioPorId(mision.stats.mercenariosAsignados[3]))
