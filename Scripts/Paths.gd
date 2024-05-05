extends Node2D
class_name Paths

var recibiendoMision = false

func aldeanoConMision(mision:Mision, aldeanoInstance):
	if recibiendoMision == false:
		recibiendoMision = true
		var path = get_tree().get_nodes_in_group("nuevaMisionPath")[0]
		var progressPath = ResourceLoader.load("res://Scenes/Paths/progress_path.tscn").instantiate()
		path.add_child(progressPath)
		var remoteTransform: RemoteTransform2D = progressPath.get_child(0)
		var length = path.curve.get_baked_length()
		var tween = get_tree().create_tween()

		remoteTransform.remote_path = aldeanoInstance.get_path()
		progressPath.progress_ratio = 0
		tween.finished.connect(aldeanoConMision2.bind(aldeanoInstance, remoteTransform, progressPath))
		tween.tween_property(progressPath,"progress", length, length/50) #lenght/# se usa para que avance 40 px por segundo

func aldeanoConMision2(aldeanoInstance, remoteTransform: RemoteTransform2D, oldProgressPath):
	oldProgressPath.queue_free()
	remoteTransform.remote_path = ""
	var path =  get_tree().get_nodes_in_group("nuevaMisionPath")[1]
	var progressPath = ResourceLoader.load("res://Scenes/Paths/progress_path.tscn").instantiate()
	path.add_child(progressPath)
	var newRemoteTransform: RemoteTransform2D = progressPath.get_child(0)
	var length = path.curve.get_baked_length()
	var tween = get_tree().create_tween()
	
	newRemoteTransform.remote_path = aldeanoInstance.get_path()
	progressPath.progress_ratio = 0
	aldeanoInstance.entrarEnGremio(progressPath, length, tween)

func aldeanoSinMision(aldeanoInstance):
		var path = get_tree().get_nodes_in_group("nuevaMisionPath")[1]
		var progressPath = ResourceLoader.load("res://Scenes/Paths/progress_path.tscn").instantiate()
		path.add_child(progressPath)
		var remoteTransform: RemoteTransform2D = progressPath.get_child(0)
		var length = path.curve.get_baked_length()
		var tween = get_tree().create_tween()
		
		aldeanoInstance.misionLista = false
		
		remoteTransform.remote_path = aldeanoInstance.get_path()
		progressPath.progress_ratio = length
		tween.finished.connect(aldeanoSinMision2.bind(aldeanoInstance, remoteTransform))
		tween.tween_property(progressPath,"progress", 0, length/50)

func aldeanoSinMision2(aldeanoInstance, remoteTransform):
	remoteTransform.remote_path = ""
	var path =  get_tree().get_nodes_in_group("nuevaMisionPath")[0]
	var progressPath = ResourceLoader.load("res://Scenes/Paths/progress_path.tscn").instantiate()
	path.add_child(progressPath)
	var newRemoteTransform: RemoteTransform2D = progressPath.get_child(0)
	var length = path.curve.get_baked_length()
	var tween = get_tree().create_tween()
	
	newRemoteTransform.remote_path = aldeanoInstance.get_path()
	progressPath.progress_ratio = length
	await aldeanoInstance.salirDelGremio(progressPath, length, tween)
	recibiendoMision = false

func nuevoTranseunte(aldeanoInstance):
	var paths = get_tree().get_nodes_in_group("transeuntePath")
	var pathElegido = paths[randi_range(0, paths.size() - 1)]
	
	var progressPath = ResourceLoader.load("res://Scenes/Paths/progress_path.tscn").instantiate()
	pathElegido.add_child(progressPath)
	var remoteTransform: RemoteTransform2D = progressPath.get_child(0)
	var length = pathElegido.curve.get_baked_length()
	var tween = get_tree().create_tween()
	
	progressPath.progress_ratio = 0
	remoteTransform.remote_path = aldeanoInstance.get_path()
	aldeanoInstance.transitar(progressPath, length, tween)

func nuevoMercenario(mercenario: Mercenario, mercenarioInstance):
	mercenarioInstance.mercenario = mercenario
	var availablePaths = getAvailableMercenaryPaths()
	
	if availablePaths.size() != 0:
		var pathElegido = availablePaths[randi_range(0, availablePaths.size() - 1)]
		
		var progressPath = ResourceLoader.load("res://Scenes/Paths/progress_path.tscn").instantiate()
		pathElegido.add_child(progressPath)
		var remoteTransform: RemoteTransform2D = progressPath.get_child(0)
		var length = pathElegido.curve.get_baked_length()
		var tween = get_tree().create_tween()
		
		progressPath.progress_ratio = 0
		remoteTransform.remote_path = mercenarioInstance.get_path()
		mercenarioInstance.transitar(progressPath, length, tween)

func getAvailableMercenaryPaths():
	var paths = get_tree().get_nodes_in_group("mercenaryPath")
	var result = []
	
	for path in paths:
		if path.get_child_count() == 0:
			result.append(path)
	
	return result
