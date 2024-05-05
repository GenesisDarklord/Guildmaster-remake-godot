class_name Objeto

var stats: Dictionary = {
	#GENERAL
	"id": 0,
	"nombre": "",
	"descripcion": "",
	"rareza": 0,
	"precio": 0, # precio en caso de estar en la tienda
	"valor": 0, # valor en cao de venderse
	"tipo": "", # tipo de objeto, entre material, equipamiento
	"tiempoDeFabricacion": 0,
	"obtenibleDeMercader": false,
	"obtenibleDeMision": false,
	"cantidad": 0,
	"cantEnUso": 0,
	"icono": "", #el nombre del archivo del sprite que se debe usar
	"coords": Vector2(0,0), #coordenas del grid del sprite
	
	#MATERIALS
	"material_1": "",
	"cantMaterial_1": 0,
	"material_2": "",
	"cantMaterial_2": 0,
	"material_3": "",
	"cantMaterial_3": 0,
	
	#STATS
	"ataque": 0,
	"defensa": 0,
	"fuerza": 0,
	"destreza": 0,
	"sabiduria": 0
}

func _init(id, nombre, tipo, descripcion,
material_1, cantMaterial_1, material_2, cantMaterial_2, material_3, cantMaterial_3,
ataque, defensa, fuerza, destreza, sabiduria, precio, valor,
rareza,  tiempoDeFabricacion, obtenibleDeMercader, obtenibleDeMision, coords, icono):
	
	#GENERAL
	stats.id = id.to_int()
	stats.nombre = nombre
	stats.tipo = tipo
	stats.descripcion = descripcion
	stats.precio = precio.to_int()
	stats.rareza = rareza.to_int()
	stats.valor = valor.to_int()
	stats.tiempoFabricacion = tiempoDeFabricacion.to_int()
	stats.obtenibleDeMercader = true if obtenibleDeMercader == "Si" else false
	stats.obtenibleDeMision = true if obtenibleDeMision == "Si" else false
	stats.coords = Vector2(coords.split("-")[0].to_int(), coords.split("-")[1].to_int())
	stats.icono = icono
	
	#MATERIALS
	stats.material_1 = material_1
	stats.cantMaterial_1 = cantMaterial_1.to_int()
	stats.material_2 = material_2
	stats.cantMaterial_2 = cantMaterial_2.to_int()
	stats.material_3 = material_3
	stats.cantMaterial_3 = cantMaterial_3.to_int()
	
	#STATS
	stats.ataque = ataque.to_int()
	stats.defensa= defensa.to_int()
	stats.fuerza = fuerza.to_int()
	stats.destreza = destreza.to_int()
	stats.sabiduria = sabiduria.to_int()















