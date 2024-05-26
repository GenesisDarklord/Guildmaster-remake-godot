extends Node

var TIME = {
	"hora": 6,
	"minutos": 0,
	"dia": 1,
	"mes": 1,
	"year": 0,
	"tiempoTranscurrido": 0.0 #se usa para saber cuanto tiempo en segundos ha pasado del dia
}

#var hora = 0
#var minutos = 0
#var dia = 0
#var mes = 0
#var year = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	TIME.dia = 1
	TIME.mes = 1
	TIME.hora = 6
	TIME.minutos = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	TIME.tiempoTranscurrido += 1 * delta
	comprobarLimites()

func comprobarLimites():
	if TIME.minutos > 59:
		TIME.minutos = 0
		TIME.hora += 1
	if TIME.hora > 23:
		TIME.hora = 0
		#TIME.dia += 1
	if TIME.dia > 28:
		TIME.dia = 1
		TIME.mes += 1
	if TIME.mes > 12:
		TIME.mes = 1
		TIME.year += 1

func pasarDia():
	TIME.tiempoTranscurrido = 0.0
	TIME.dia += 1
	TIME.hora = 6
	TIME.minutos = 0

func reset():
	TIME = {
	"hora": 6,
	"minutos": 0,
	"dia": 1,
	"mes": 1,
	"year": 0,
	"tiempoTranscurrido": 0.0 #se usa para saber cuanto tiempo en segundos ha pasado del dia
}
