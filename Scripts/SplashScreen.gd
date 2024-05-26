extends CanvasLayer

func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _on_animation_player_animation_finished(anim_name):
	get_tree().change_scene_to_file("res://Scenes/Pantallas/MenuPrincipal.tscn")
