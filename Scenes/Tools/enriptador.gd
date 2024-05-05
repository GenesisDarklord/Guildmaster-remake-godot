extends Node2D


func _on_button_pressed():
	var misionesFile = FileAccess.open("res://DATABASES/Misiones.csv",FileAccess.READ)
	var misionesFileEncripted = FileAccess.open_encrypted_with_pass("data/misiones.csv",FileAccess.WRITE,"Konata")
	misionesFileEncripted.store_string(misionesFile.get_as_text())
	misionesFile = null
	misionesFileEncripted = null


func _on_button_2_pressed():
	pass # Replace with function body.
