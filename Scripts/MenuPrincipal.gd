extends CanvasLayer

@onready var music = $AudioStreamPlayer


func _ready() -> void:
	get_tree().set_current_scene(self)

func _process(delta: float) -> void:
	pass

func _on_nuevaPartida_btn_pressed() -> void:
	System.nuevaPartida()

func _on_cargar_partida_btn_pressed():
	System.cargarPartida()


func _on_salir_btn_pressed():
	get_tree().quit()
