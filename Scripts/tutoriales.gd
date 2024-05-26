extends Control

@export var tutorialPanel: Sprite2D
@export var nextBtn: TextureButton
@export var prevBtn: TextureButton


func _ready():
	nextBtn.visible = false
	prevBtn.visible = false
	tutorialPanel.frame = 0
	self.visible = false

func mostrarTutoriales():
	self.visible = true
	nextBtn.visible = true
	tutorialPanel.frame = 0

func cerrarTutoriales():
	self.visible = false
	nextBtn.visible = false
	prevBtn.visible =  false

func proximaPagina():
	tutorialPanel.frame += 1
	prevBtn.visible = true
	
	if tutorialPanel.frame == 5:
		nextBtn.visible = false

func ateriorPagina():
	tutorialPanel.frame -= 1
	nextBtn.visible = true
	
	if tutorialPanel.frame == 0:
		prevBtn.visible = false

