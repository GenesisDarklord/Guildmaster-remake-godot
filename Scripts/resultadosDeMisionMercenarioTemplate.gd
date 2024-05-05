extends TextureRect
@export var nombre: String
@export var expGanada: float
@export var expInicial: float
@export var expFinal: float
var mercenario: Mercenario
@export var expBar: TextureProgressBar
@export var expGained: Label

var tweens = [] #contiene todos los tweens usados en el nodo

func _ready():
	pass

func _process(delta):
	pass

func start():
	#if mercenario != null:
		
		playExpGained()
		iniciarLLenadoExp()

func cargar(mercenario: Mercenario, exp):
	self.mercenario = mercenario
	self.expGanada = exp
	self.texture = ResourceLoader.load(mercenario.stats.retrato)
	expInicial = mercenario.stats.XP
	expFinal = expInicial + expGanada
	actualizarXP()
	actualizarProgressBar()

func actualizarXP():
	expGained.modulate = Color(1,1,1,0)
	expGained.text = "+ " + str(expGanada) + " XP"

func actualizarProgressBar():
	expBar.value = expInicial

func iniciarLLenadoExp():
	var tween: Tween
	tween = get_tree().create_tween()
	tweens.append(tween)
	
	if expFinal > 100:
		tween.tween_property(expBar,"value",100,1)
		tween.tween_callback(tweenFinished)
	elif expFinal != 0:
		tween.tween_property(expBar,"value",expFinal,1)
		tween.tween_callback(tweenFinished)
	
	await tween.finished
	tweens.erase(tween)

func tweenFinished():
	if expBar.value == 100:
		playLvlUp()
		expBar.value = 0
		expFinal = expFinal - 100
		expInicial = 0
		call_deferred("iniciarLLenadoExp")

func playExpGained():
	var tween: Tween
	tween = get_tree().create_tween()
	tweens.append(tween)
	
	expGained.position = Vector2(37,5)
	tween.tween_property(expGained, "position",Vector2(37,-8),0.5)
	tween.parallel().tween_property(expGained,"modulate",Color(1,1,1,1),0.5)
	
	await tween.finished
	tweens.erase(tween)

func playLvlUp():
	var tween: Tween
	tween = get_tree().create_tween()
	tweens.append(tween)
	
	$lvl_up.position = Vector2(125, 5)
	$lvl_up.modulate = Color(1,1,1,0)
	tween.tween_property($lvl_up,"position",Vector2(125, -5), 0.4)
	tween.parallel().tween_property($lvl_up, "modulate", Color(1,1,1,1), 0.4)
	tween.tween_property($lvl_up,"modulate",Color(1,1,1,0),0.2)
	
	await tween.finished
	tweens.erase(tween)

func reset():
	for tween in tweens:
		if tween.is_running():
			tween.stop()
