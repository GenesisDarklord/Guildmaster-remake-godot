class_name Mercenario

@export var stats = {
	"id": 0,
	"retrato": null,
	"nombre": "",
	"rango":0,
	"XP": 0,
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

func _init(id, nombre, rango, ataque, defensa):
	stats.id = id
	stats.retrato = "res://atlas/MercenarioIcon.tres"
	stats.nombre = nombre
	stats.rango = rango
	stats.ataque = ataque
	stats.defensa = defensa
	stats.XP = 0
