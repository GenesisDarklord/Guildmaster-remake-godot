extends TextureRect

var misionTemplate = preload("res://Scenes/misionTemplate.tscn")
@onready var container = $ScrollContainer/VBoxContainer
 
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func llenarListaMisiones():
	if System.SystemStats.misionesAceptadas.size() > 0:
		for misionID in System.SystemStats.misionesAceptadas:
			var mision = System.buscarMisionPorId(misionID)
			var misionInstance = misionTemplate.instantiate()
			misionInstance.call("mostrarDatos", mision)
			container.add_child(misionInstance)
