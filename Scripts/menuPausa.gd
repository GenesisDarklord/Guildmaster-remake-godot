extends TextureRect

@export var panelesActivos: PanelesActivos
@export var gremioInstace: Node2D
signal menuPrincipal


func _process(delta):
	mostrarPanelPausa()

func mostrarPanelPausa():
	if Input.is_action_just_pressed("escape"):
		if visible == false:
			#panelesActivos.cerrarPaneles()
			visible = true
			get_tree().paused = true
		else:
			visible = false
			get_tree().paused = false

func _on_reanudar_btn_pressed():
	visible = false
	get_tree().paused = false

func _on_menu_principal_btn_pressed():
	emit_signal("menuPrincipal")
