class_name Mision

@export var stats = {
	"id": 0,
	"nombre": "",
	"descripcion": "",
	"cliente": "",
	"lugar": "",
	"drakmar": 0,
	"XP": 0,
	"prestigio": 0,
	"duracion": 0,
	"diasRestantes": 0,
	"esPrincipal": false,
	
	"rangoMision": 0,
	"recompensa": [],
	"enCurso": false,
	"mercenariosAsignados": [], #Almacena el ID de los mercenarios que se asignaron
}
#@export var id: int
#@export var nombre: String
#@export var descripcion: String
#@export var cliente: String
#@export var lugar: String
#@export var drakmar: int
#@export var XP: int
#@export var prestigio: int
#@export var duracion: int
#@export var esPrincipal: bool
#
#@export var rangoMision: int
#@export var recompensa: float
#@export var enCurso: bool
#@export var mercenariosAsignados = []

#Constructor de la clase
func _init(
	id:int,
	nombre:String, 
	descripcion: String, 
	cliente: String, 
	lugar:String, 
	recompensa: String,
	drakmar:int, 
	XP:int, 
	prestigio: int, 
	duracion:int, 
	esPrincipal) -> void:
	
	stats.id = id
	stats.nombre = nombre
	stats.descripcion = descripcion
	stats.cliente = cliente
	stats.lugar = lugar
	stats.recompensa = Array(recompensa.split(",")) if recompensa != "" else null
	stats.drakmar = drakmar
	stats.XP = XP
	stats.prestigio = prestigio
	stats.duracion = duracion
	stats.diasRestantes = duracion
	
	if esPrincipal == "Si":
		stats.esPrincipal = true
	else:
		stats.esPrincipal = false

func guardarDatos():
	return stats

func cargarDatos(dic: Dictionary):
	stats = dic
