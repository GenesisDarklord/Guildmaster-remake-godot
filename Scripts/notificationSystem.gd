extends Control
class_name NotificationSystem

var notifications = [] #para la cola de notificaciones
var isNotificating = false #para cuando este notificando
@onready var notificationLabel = $notificationLabel
@onready var animator = $notificationAnimator

enum Type {
	NEW_MERCENARY = 0,
	NEW_MISION = 1,
}

func _process(delta):
	if isNotificating == false and notifications.size() > 0:
		notify()

func addNotification(type: int):
	notifications.push_back(type)

func notify():
	if notifications.front() == Type.NEW_MISION:
		notificationLabel.text = "Parece que un aldeano ha traido una mision nueva"
	
	if notifications.front() == Type.NEW_MERCENARY:
		notificationLabel.text = "Acaba de aparecer un mercenario nuevo"
	
	notifications.pop_front()
	isNotificating = true
	animator.play("show_notification")

func _on_notification_animator_animation_finished(anim_name):
	isNotificating = false

func _on_button_6_pressed():
	addNotification(Type.NEW_MISION)
