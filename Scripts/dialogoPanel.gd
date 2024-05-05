extends NinePatchRect

@export var velocidad: float
@export var texto: RichTextLabel
@export var nombre: Label
@export var cursor: TextureRect
@export var animaciones: AnimationPlayer
@export var cursorAnimaciones: AnimationPlayer
@export var cinematicas: AnimationPlayer
@export var enCurso: bool
@export var clickBtn: TextureButton

func _ready():
	pass

func _process(delta):
	if texto.visible_ratio >= 1:
		animaciones.pause()
		enCurso = false
		cursor.visible = true
	else:
		cursor.visible = false

func mostrarDialogo():#Esta funcion es para mostrar dialogo de forma generica
	pass

func monstrarLineaDialogo(dialogo: String, nombre: String):#esta funcion se usa para mostrar dialogo en cinematicas
	cinematicas.pause()
	texto.text = dialogo
	self.nombre.text = nombre
	enCurso = true
	animaciones.speed_scale = velocidad
	clickBtn.visible = true
	self.visible = true
	animaciones.play("mostrarDialogo")

func _on_click_btn_pressed():
	if enCurso:
		animaciones.advance(5)
		enCurso = false
	else:
		animaciones.stop()
		clickBtn.visible = false
		self.visible = false
		cinematicas.play()
