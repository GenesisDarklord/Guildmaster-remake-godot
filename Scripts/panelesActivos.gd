class_name PanelesActivos
extends HBoxContainer

var misionesPanel = preload("res://Scenes/Menus/misionesPanel.tscn")
var nuevaMisionPanel = preload("res://Scenes/Menus/nuevaMisionPanel.tscn")
var detallesMisionPanel = preload("res://Scenes/Menus/detallesMisionPanel.tscn")
var nuevoMercenarioPanel = preload("res://Scenes/Menus/nuevoMercenarioPanel.tscn")
var detallesMercenarioPanel = preload("res://Scenes/Menus/detallesMercenarioPanel.tscn")
var mercenariosPanel = preload("res://Scenes/Menus/mercenariosPanel.tscn")
var almacenPanel = preload("res://Scenes/Menus/almacenPanel.tscn") 
var detallesObjetoPanel = preload("res://Scenes/Menus/detallesObjetoPanel.tscn")

@export var panelesInactivos: HBoxContainer
@export var pauseMenu: TextureRect
signal IniciarMision(mision:Mision)


func _ready():
	pass

func _process(delta):
	pass
#-----------------PARA LAS MISIONES--------------------------
func mostrarPanelNuevaMision(mision:Mision):
	if $nuevaMisionPanel == null:
		add_child(nuevaMisionPanel.instantiate())
		$nuevaMisionPanel.call("llenarDatos", mision)

func mostrarMisionesPanel():
	cerrarPaneles()
	if $misionesPanel == null:
		add_child(misionesPanel.instantiate())
		$misionesPanel.call("llenarListaMisiones")
	else:
		cerrarMisionesPanel()

func mostrarDetallesDeMision(mision: Mision):
	if $detallesMisionPanel == null:
		add_child(detallesMisionPanel.instantiate())
		$detallesMisionPanel.call("llenarDatos", mision)
#		$detallesMisionPanel.get_node("iniciarMision_btn").set("visible", true)
	else:
		$detallesMisionPanel.free()
		add_child(detallesMisionPanel.instantiate())
		$detallesMisionPanel.call("llenarDatos", mision)
#		$detallesMisionPanel.get_node("iniciarMision_btn").set("visible", true)

func MostrarPanelPreparingMision(mision:Mision):
	emit_signal("IniciarMision",mision)

func iniciarMision(mision:Mision):
	cerrarPaneles()
	MostrarPanelPreparingMision(mision)
#	mostrarMercenariosPanel()

func cerrarMisionesPanel():
	if $misionesPanel != null:
		$misionesPanel.queue_free()

func cerrarNuevaMisionPanel():
	if $nuevaMisionPanel != null:
		$nuevaMisionPanel.queue_free()

func cerrarDetallesMisionPanel ():
	if $detallesMisionPanel != null:
		$detallesMisionPanel.queue_free()

#----------------PARA LOS MERCENARIOS-------------------------
func mostrarNuevoMercenarioPanel(mercenario: Mercenario):
	if $nuevoMercenarioPanel == null:
		add_child(nuevoMercenarioPanel.instantiate())
		$nuevoMercenarioPanel.call("llenarDatos", mercenario)

func mostrarDetallesMercenarioPanel(mercenario: Mercenario):
	if $detallesMercenarioPanel == null:
		add_child(detallesMercenarioPanel.instantiate())
		$detallesMercenarioPanel.call("llenarDatos", mercenario)
	else:
		$detallesMercenarioPanel.free()
		add_child(detallesMercenarioPanel.instantiate())
		$detallesMercenarioPanel.call("llenarDatos", mercenario)

func mostrarMercenariosPanel():
	if $mercenariosPanel == null:
		cerrarMercenariosPanel()
		add_child(mercenariosPanel.instantiate())
		$mercenariosPanel.call("llenarListaMercenarios")
	else:
		cerrarMercenariosPanel()

func equiparMercenario(tipo: String):
	Flags.equipandoMercenario = true
	
	if $almacenPanel == null:
		mostrarAlmacenPanel()
	
	if tipo == "arma":
		$almacenPanel.call("filtrarArmas")
	if tipo == "armadura":
		$almacenPanel.call("filtrarArmaduras")

func cerrarNuevoMercenarioPanel():
	if $nuevoMercenarioPanel != null:
		$nuevoMercenarioPanel.queue_free()

func cerrarDetallesMercenarioPanel():
	Flags.equipandoMercenario = false
	
	if $detallesMercenarioPanel != null:
		$detallesMercenarioPanel.queue_free()
	
	if $almacenPanel != null:
		$almacenPanel.queue_free()

func cerrarMercenariosPanel():
	cerrarDetallesMercenarioPanel()
	if $mercenariosPanel != null:
		$mercenariosPanel.queue_free()
#----------------PARA LOS OBJETOS------------------------------

func mostrarAlmacenPanel():
	if $almacenPanel == null:
		cerrarAlmacenPanel()
		add_child(almacenPanel.instantiate())
		$almacenPanel.call("list_objects")
	else:
		cerrarAlmacenPanel()

func mostrarDetallesObjetoPanel(objeto: Objeto):
	if $detallesObjetoPanel == null:
		add_child(detallesObjetoPanel.instantiate())
		$detallesObjetoPanel.call("configure", objeto)
	else:
		$detallesObjetoPanel.free()
		add_child(detallesObjetoPanel.instantiate())
		$detallesObjetoPanel.call("configure", objeto)

func cerrarAlmacenPanel():
	if $almacenPanel != null:
		$almacenPanel.queue_free()
	if $detallesObjetoPanel != null:
		$detallesObjetoPanel.queue_free()

func cerrarDetallesObjetosPanel():
	if $detallesObjetoPanel != null:
		$detallesObjetoPanel.queue_free()
#----------------PARA LOS BOTONES------------------------------

func _on_cerrar_paneles_pressed():
	cerrarPaneles()

func _on_misiones_btn_pressed():
	mostrarMisionesPanel()

func _on_mercenarios_btn_pressed():
	mostrarMercenariosPanel()

func _on_almacen_btn_pressed():
	mostrarAlmacenPanel()

#------------------OTRAS FUNCIONES-----------------------------
func cerrarPaneles():
	cerrarDetallesMisionPanel()
	cerrarMisionesPanel()
	cerrarNuevaMisionPanel()
	cerrarDetallesMercenarioPanel()
	cerrarNuevoMercenarioPanel()
	cerrarMercenariosPanel()
	cerrarAlmacenPanel()
	cerrarDetallesObjetosPanel()
	Flags.preparandoMision = false

