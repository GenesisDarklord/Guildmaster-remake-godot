extends AnimationPlayer

func _ready():
	pass

func prepararCinematica():#esta funcion oculta la instancia del gremio para la cinematica
	get_tree().get_nodes_in_group("Gremio")[0].visible = false
	get_tree().get_nodes_in_group("GUI")[0].visible = false
	get_tree().get_nodes_in_group("CanvasModulate")[0].visible = false
	get_tree().get_nodes_in_group("cinematicsCamera")[0].make_current()
	get_tree().paused = true

func terminarCinematica():#esta funcion vuelve a mostrar la instancia del gremio
	get_tree().get_nodes_in_group("Gremio")[0].visible = true
	get_tree().get_nodes_in_group("GUI")[0].visible = true
	get_tree().get_nodes_in_group("CanvasModulate")[0].visible = true
	get_tree().paused = false
	get_tree().get_nodes_in_group("mainCamera")[0].make_current()

func pausarJuego():
	get_tree().paused = true

func reanudarJuego():
	get_tree().paused = false

func iniciarCicloDiaNoche():
	get_tree().get_nodes_in_group("cicloDiaNoche")[0].play("ciclo")
