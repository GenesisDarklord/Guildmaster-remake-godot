extends CanvasLayer

signal entrarGremio
signal salirGremio
signal menuPrincipal
signal abrirHerreria
signal abrirMercado
signal abrirTutoriales

func entrar_gremio():
	emit_signal("entrarGremio") 

func salir_gremio():
	emit_signal("salirGremio")

func toMenuPrincipal():
	emit_signal("menuPrincipal")

func abrir_herreria():
	emit_signal("abrirHerreria")

func abrir_mercado():
	emit_signal("abrirMercado")

func abrir_tutoriales():
	emit_signal("abrirTutoriales")

func mostrarPanelPreparingMision(mision: Mision):
	$PreparingMisionPanel.MostrarPanel(mision)

func _on_button_pressed():
	System.mostrarPopUp("TEXTO DE PRUEBA")
