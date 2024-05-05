extends Node2D
class_name mercenary

var mercenario: Mercenario = null
var mercenarioListo: bool = false
var progressPath: PathFollow2D = null
@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D
var oldPos: Vector2 = Vector2(0,0)
var direction: Vector2 = Vector2(0,0)


func _ready():
	oldPos = position

func _process(delta):
	updateDirection()
	updateAnimation()

func transitar(progressPath: PathFollow2D,length, tween: Tween):
	self.progressPath = progressPath
	tween.connect("finished", prepararMercenario)
	tween.tween_property(self.progressPath,"progress", length, length/50)

func prepararMercenario():
	var notificationSystem: NotificationSystem = get_tree().get_nodes_in_group("notificationSystem")[0]
	notificationSystem.addNotification(notificationSystem.Type.NEW_MERCENARY)
	mercenarioListo = true

func updateDirection():
	if oldPos == position:
		direction = Vector2(0,0)
	else:
		direction = position - oldPos
	oldPos = position

func updateAnimation():
	if direction == Vector2(0,0):
		animatedSprite.play("idle")
	elif direction.x > 0.2:
		animatedSprite.play("walk_right")
		animatedSprite.flip_h = false
	elif direction.x < -0.2:
		animatedSprite.play("walk_right")
		animatedSprite.flip_h = true
	elif direction.y > 0.2:
		animatedSprite.play("walk_down")
	elif direction.y < -0.2:
		animatedSprite.play("walk_up")

func _on_texture_button_pressed():
	if mercenarioListo:
		var panelesActivos:PanelesActivos = get_tree().get_nodes_in_group("panelesActivos")[0]
		panelesActivos.mostrarNuevoMercenarioPanel(mercenario)
		progressPath.queue_free()
		queue_free()
