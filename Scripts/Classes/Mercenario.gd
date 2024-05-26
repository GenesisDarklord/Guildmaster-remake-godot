class_name Mercenario

@export var stats = {
	"id": 0,
	"retrato": null,
	"nombre": "",
	"rango":0,
	"clase": "",
	"nombreClase": "",
	"XP": 0,
	"aburrimiento": 10,
	"enMision": false,
	
	#EQUIPMENT
	"arma": null,
	"armadura": null,
	"accesorio": null,
	"accesorio2": null,
	
	#STATS
	"ataque": 0,
	"defensa": 0,
	"fuerza": 0,
	"destreza": 0,
	"sabiduria": 0
}

var clases = {
	'Guerrero': ['Guerrero', 'Guardia','Caballero', 'Paladin',],
	'Mago': ['Mago', 'Brujo', 'Archimago', 'Sacerdote'],
	'Ladron': ['Ladron', 'Bandido', 'Asesino', 'Ninja'],
	'Monje': ['Monje', 'Pugilista', 'Exorcista', 'Alto Monje']
}

var statsPorClase = {
	'Guerrero' : {
		'fuerza': 10,
		'destreza': 3,
		'sabiduria': 2
	},
	'Mago': {
		'fuerza': 2,
		'destreza': 5,
		'sabiduria': 10
	},
	'Ladron': {
		'fuerza': 4,
		'destreza': 10,
		'sabiduria': 2
	},
	'Monje':{
		'fuerza': 7,
		'destreza': 7,
		'sabiduria': 7
	}
}
#var retrato
#var nombre
#var rango
#
##EQUIPMENT
#var arma = null
#var armadura = null
#var accesorio1 = null
#var accesorio2 = null
#
##STATS
#var ataque = 0
#var defensa = 0
#var fuerza = 0
#var destreza = 0
#var sabiduria = 0
#
#var enMision = false

func _init(id, nombre, rango, ataque, defensa, clase):
	stats.id = id
	stats.retrato = "res://atlas/MercenarioIcon.tres"
	stats.nombre = nombre
	stats.rango = rango
	stats.clase = clase
	stats.ataque = ataque
	stats.defensa = defensa
	stats.XP = 0
	
	if stats.clase != null:
		modificarStatsSegunClase()
		actualizarNombreClase()

func ganarXP(cantidad):
	stats.XP += cantidad
	while stats.XP >=100:
		stats.XP -= 100
		stats.rango += 1
		modificarStatsSegunClase()
		actualizarNombreClase()

func actualizarNombreClase():
	var nivelEvolucion = int(stats.rango / 5)
	
	stats.nombreClase = clases.get(stats.clase)[nivelEvolucion]

func modificarStatsSegunClase():
	if stats.clase != null:
		stats.fuerza = statsPorClase.get(stats.clase).fuerza * stats.rango
		stats.destreza = statsPorClase.get(stats.clase).destreza * stats.rango
		stats.sabiduria = statsPorClase.get(stats.clase).sabiduria * stats.rango
