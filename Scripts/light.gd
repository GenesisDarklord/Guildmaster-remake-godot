extends Node2D

@onready var light = $light
@onready var shadows = $shadows
@onready var SFX = $SFX

func _ready():
	pass

func _on_visible_on_screen_enabler_2d_screen_entered():
#	self.visible = true
	pass

func _on_visible_on_screen_enabler_2d_screen_exited():
#	self.visible = false
	pass

func encender():
	var tiempoParaEncender = randi_range(0,5)
	var timer = get_tree().create_timer(tiempoParaEncender)
	timer.connect("timeout", encender2)

func encender2():
	SFX.playing = true
	self.visible = true

func apagar():
	SFX.playing = false
	self.visible = false
