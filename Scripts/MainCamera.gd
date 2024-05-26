extends Camera2D

var speed = 300
var moving = false
var direction
var ruedaDirection
var limitLeft = -938
var limitRight = 552
var limitUp = -695
var limitDown = 695

func _ready():
	make_current()
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	limitMovement()
	moveCamera(delta)
	changeZoom(delta)

func _input(event):
	var screen_size
	screen_size = get_viewport_rect().size
	
	if event is InputEventMouseMotion:
		var mouse_pos = event.position
		var border_size = 15# Ajusta este valor según tus necesidades
		
		if mouse_pos.x < border_size:
			move_camera(Vector2(-1, 0))
		elif mouse_pos.x > screen_size.x - border_size:
			move_camera(Vector2(1, 0))
		elif mouse_pos.y < border_size:
			move_camera(Vector2(0, -1))
		elif mouse_pos.y > screen_size.y - border_size:
			move_camera(Vector2(0, 1))
		else:
			moving = false

func move_camera(direction):
	moving = true
	self.direction = direction
#	position += direction * speed * get_process_delta_time()


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
		
		if moving:
			transform.origin += direction * (speed / zoom.x) * delta

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
