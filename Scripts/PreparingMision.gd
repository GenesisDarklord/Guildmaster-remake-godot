extends Control

@onready var equilibrio: StaticBody2D = $Balanza/equilibrio
@onready var detallesMision = $detallesMisionPanel
@onready var mercenariosPanel = $mercenariosPanel

func _ready():
	self.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	if Flags.preparandoMision:
#		ActualizarAnguloBalanza()
	pass

func MostrarPanel(mision:Mision):
	detallesMision.llenarDatos(mision)
	mercenariosPanel.llenarListaMercenarios()
	equilibrio.rotation_degrees = -25
	Flags.preparandoMision = true
	self.visible = true
	ActualizarAnguloBalanza()

func ComenzarMision():
	self.visible = false
	Flags.preparandoMision = false
	mercenariosPanel.LimpiarLista()

func CerrarPanel():
	self.visible = false
	Flags.preparandoMision = false
	mercenariosPanel.LimpiarLista()
	detallesMision.LimpiarMercenariosAsignados()

func ActualizarAnguloBalanza():
	var mision: Mision = detallesMision.mision
	var sumaAtaques = 0
	
	for mercenarioID in mision.stats.mercenariosAsignados:
		sumaAtaques += System.buscarMercenarioPorId(mercenarioID).stats.ataque
	
	var angulo = sumaAtaques - mision.stats.XP
	
	if angulo > 25:
		angulo = 25
	if angulo < -25:
		angulo = -25
		
	var tween = get_tree().create_tween()
	tween.tween_property(equilibrio,"rotation_degrees",angulo, 0.5)





