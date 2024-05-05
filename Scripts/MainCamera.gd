extends Camera2D

var speed = 300
var limitLeft = -938
var limitRight = 938
var limitUp = -715
var limitDown = 715

func _ready():
	make_current()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	limitMovement()
	moveCamera(delta)
	changeZoom(delta)

func moveCamera(delta):
	if is_current():
		if Input.is_action_pressed("down"):
			transform.origin += Vector2.DOWN * (speed / zoom.x) * delta
		if Input.is_action_pressed("up"):
			transform.origin += Vector2.UP * (speed / zoom.x) * delta
		if Input.is_action_pressed("left"):
			transform.origin += Vector2.LEFT * (speed / zoom.x) * delta
		if Input.is_action_pressed("right"):
			transform.origin += Vector2.RIGHT * (speed / zoom.x) * delta
		
func limitMovement():
	if position.x < limitLeft + (250 / zoom.x):
		position.x = limitLeft + (250 / zoom.x)
	if position.x > limitRight - (250 / zoom.x):
		position.x = limitRight - (250 / zoom.x)
	if position.y < limitUp + (175 / zoom.y):
		position.y = limitUp + (175 / zoom.y)
	if position.y > limitDown - (175 / zoom.y):
		position.y = limitDown - (175 / zoom.y)

func changeZoom(delta):
	if is_current():
		if Input.is_action_pressed("rollDown") and zoom > Vector2(0.5,0.5):
			zoom -= Vector2(1,1) * delta
		if Input.is_action_pressed("rollUp")and zoom < Vector2(1,1):
			zoom += Vector2(1,1) * delta
