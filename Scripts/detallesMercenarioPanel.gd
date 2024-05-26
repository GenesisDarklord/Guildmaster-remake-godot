extends TextureRect

var mercenario: Mercenario
@onready var weaponIcon: Sprite2D = $equipment/weapon_btn/weapon_icon
@onready var armorIcon: Sprite2D = $equipment/armor_btn/armor_icon


# Called when the node enters the scene tree for the first time.
func _ready():
	Flags.equipandoMercenarioArma = false
	Flags.equipandoMercenario = false
	Flags.equipandoMercenarioArmadura = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func llenarDatos(mercenario: Mercenario):
	self.mercenario = mercenario
	$nombre_text.text = mercenario.stats.nombre
	$rango_text.text = str(mercenario.stats.rango)
	$ataque_text.text = str(mercenario.stats.ataque)
	$defensa_text.text = str(mercenario.stats.defensa)
	$XP_text.text = str(mercenario.stats.XP)
	$XP_bar.value = mercenario.stats.XP
	$clase_text.text = mercenario.stats.nombreClase
	
	actualizarVistaEquipamiento()
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
	
	for child in container.get_children():
		if child.visible == true:
			child.queue_free()
	
	for i in range(cantidad):
		var instance = indicador.duplicate()
		instance.visible = true
		container.add_child(instance)

func actualizarVistaEquipamiento():
	var arma = System.buscarObjetoPorId(mercenario.stats.arma)
	var armadura = System.buscarObjetoPorId(mercenario.stats.armadura)
	
	if mercenario.stats.arma != null:
		weaponIcon.visible = true
		weaponIcon.frame_coords = arma.stats.coords
	else:
		weaponIcon.visible = false
		
	if mercenario.stats.armadura != null:
		armorIcon.visible = true
		armorIcon.frame_coords = armadura.stats.coords
	else:
		armorIcon.visible = false

func agregarEquipamiento(objeto):
	if objeto.stats.tipo == "Arma" and objeto.stats.cantidad > 0:
		if mercenario.stats.arma != null:
			quitarEquipamiento('arma')
		mercenario.stats.arma = objeto.stats.id
		objeto.stats.cantidad -= 1
		mercenario.stats.ataque += objeto.stats.ataque
		get_tree().get_nodes_in_group("panelesActivos")[0].call("equiparMercenario", "arma")
	if objeto.stats.tipo == "Armadura" and objeto.stats.cantidad > 0:
		if mercenario.stats.armadura != null:
			quitarEquipamiento('armadura')
		mercenario.stats.armadura = objeto.stats.id
		objeto.stats.cantidad -= 1
		mercenario.stats.defensa += objeto.stats.defensa
		get_tree().get_nodes_in_group("panelesActivos")[0].call("equiparMercenario", "armadura")
	
	llenarDatos(mercenario)

func quitarEquipamiento(tipo):
	if tipo == 'arma':
		var objeto = System.buscarObjetoPorId(mercenario.stats.arma)
		if objeto != null:
			mercenario.stats.arma = null
			mercenario.stats.ataque -= objeto.stats.ataque
			objeto.stats.cantidad += 1
		get_tree().get_nodes_in_group("panelesActivos")[0].call("equiparMercenario", "arma")
	if tipo == 'armadura':
		var objeto = System.buscarObjetoPorId(mercenario.stats.armadura)
		if objeto != null:
			mercenario.stats.armadura = null
			mercenario.stats.defensa -= objeto.stats.defensa
			objeto.stats.cantidad += 1
		get_tree().get_nodes_in_group("panelesActivos")[0].call("equiparMercenario", "armadura")
	
	llenarDatos(mercenario)


func _on_weapon_btn_pressed():
	if Flags.equipandoMercenarioArma != true:
		get_tree().get_nodes_in_group("panelesActivos")[0].call("equiparMercenario", "arma")
		Flags.equipandoMercenarioArma = true
		Flags.equipandoMercenarioArmadura = false
	else:
		quitarEquipamiento('arma')


func _on_armor_btn_pressed():
	if Flags.equipandoMercenarioArmadura != true:
		get_tree().get_nodes_in_group("panelesActivos")[0].call("equiparMercenario", "armadura")
		Flags.equipandoMercenarioArma = false
		Flags.equipandoMercenarioArmadura = true
	else:
		quitarEquipamiento('armadura')









