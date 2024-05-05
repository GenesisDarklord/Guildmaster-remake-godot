extends CanvasLayer

signal entrarGremio
signal salirGremio
signal menuPrincipal
signal abrirHerreria
signal abrirMercado

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
