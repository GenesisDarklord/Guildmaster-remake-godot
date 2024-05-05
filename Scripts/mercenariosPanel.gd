extends TextureRect

var mercenarioTemplate = preload("res://Scenes/mercenarioTemplate.tscn")
@onready var container = $ScrollContainer/VBoxContainer
 
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func llenarListaMercenarios():
	if System.SystemStats.mercenariosContratados.size() > 0:
		for mercenario in System.SystemStats.mercenariosContratados:
			var mercenarioInstance = mercenarioTemplate.instantiate()
			mercenarioInstance.call("mostrarDatos", mercenario)
			container.add_child(mercenarioInstance)

func LimpiarLista():
	for child in container.get_children():
		child.queue_free()
