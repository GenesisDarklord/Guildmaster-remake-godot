extends TextureRect

var mercenario: Mercenario
@onready var weaponIcon: Sprite2D = $equipment/weapon_btn/weapon_icon
@onready var armorIcon: Sprite2D = $equipment/armor_btn/armor_icon


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
	$XP_text.text = str(mercenario.stats.XP)
	$XP_bar.value = mercenario.stats.XP
	
	actualizarVistaEquipamiento()

func actualizarVistaEquipamiento():
	var arma = System.buscarObjetoPorId(mercenario.stats.arma)
	var armadura = System.buscarObjetoPorId(mercenario.stats.armadura)
	
	if mercenario.stats.arma != null:
		weaponIcon.visible = true
		weaponIcon.frame_coords = arma.stats.coords
	if mercenario.stats.armadura != null:
		armorIcon.visible = true
		armorIcon.frame_coords = armadura.stats.coords

func agregarEquipamiento(objeto):
	if objeto.stats.tipo == "Arma":
		mercenario.stats.arma = objeto.stats.id
	if objeto.stats.tipo == "Armadura":
		mercenario.stats.armadura = objeto.stats.id
	
	actualizarVistaEquipamiento()

func _on_weapon_btn_pressed():
	get_tree().get_nodes_in_group("panelesActivos")[0].call("equiparMercenario", "arma")


func _on_armor_btn_pressed():
	get_tree().get_nodes_in_group("panelesActivos")[0].call("equiparMercenario", "armadura")









