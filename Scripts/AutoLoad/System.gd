extends Node
var saveData = {} #Diccionario usado para el mecanismo de guardado de partida

var objetosTotales = [] # base de datos de los objetos
var misionesDisponibles = [] #base de datos de las misiones disponibles a que un aldeano las presente
var misionesTotales = [] #base de datos con todas las misiones

var SystemStats = { #Diccionario Para los stats del system
	"misionesAceptadas": [], #guarda los ID de las misiones aceptadas
	"misionesCompletadas": [], #guarda los ID de las misiones completadas
	"misionesEnCurso": [], #guarda los ID de las misiones en curso
	
	"objetosEnAlmacen": [], #guarda los ID de los objetos en el Almacen
	
	"mercenariosContratados": [], #guarda los Mercenarios contratados
	"mercenariosEnMision": [] #guarda los ID de los mercenarios en mision
}

var nombresMercenarios = [#contiene nombres por defecto de mercenarios
	"Genesis",
	"Lahars",
	"LNG2000",
	"PolariSystem",
	"Killy",
	"Ramoneitor"
]
var ConsoleEnabled = true #para activar o desactivar la consola

func _ready() -> void:
	pass

func _process(delta):
	pass

func cambiarEscena():
	pass

func guardarPartida():
	saveData["SystemStats"] = SystemStats.duplicate(true) #Escribe en savedata una copia del diccionario de SystemStats
	saveData["GremioStats"] = get_node("/root/Gremio").stats #Escribe en savedata una copia del diccionario de Stats del Gremio
	saveData["GlobalTime"] = GlobalTime.TIME #Escribe en savedata una copia del diccionario del tiempo Global
	
	#-------------------------Preparando savedata para usarlo en el guardado----------
	#
	# las listas misionesEnCurso y mercenariosContratados almacenan los IDs de las
	# misiones y los mercenarios respectivamente y es necesario que dichas listas
	# en savedata contengan los diccionarios de dichas instancias de misiones y 
	# mercenarios por tanto estos bloques de codigo se encargan de usar la funcion
	# buscarMisionPorId y buscarMercenarioPorId para obtener los diccionarios de stats
	# y escribirlos en donde corresponde
	#
	# Se ocupa para este fin la lista de misiones en curso ya que son las unicas que 
	# presentan cambios en sus stats en este caso tienen mercenarios asignados,
	# las otras son exactamente iguales a como se cargaron del csv
	saveData.SystemStats.misionesEnCurso = [] #limpia el array misionesEnCurso de saveData
	for misionID in SystemStats.misionesEnCurso: #reccorre el array de misionesEnCurso
		saveData.SystemStats.misionesEnCurso.append(buscarMisionPorId(misionID).stats)# llena el arreglo de saveData con los diccionarios de stats de las misiones
	
	saveData.SystemStats.objetosTotales = []
	for objeto in objetosTotales:
		saveData.SystemStats.objetosTotales.append(objeto.stats)
	
	saveData.SystemStats.mercenariosContratados = []
	for mercenario in SystemStats.mercenariosContratados:
		saveData.SystemStats.mercenariosContratados.append(mercenario.stats)
	#-----------------------------------------------------------------------------------
	#var savefile = FileAccess.open_encrypted_with_pass("savedata.dat",FileAccess.WRITE,OS.get_unique_id())
	var savefile = FileAccess.open("savedata.dat",FileAccess.WRITE)
	savefile.store_var(saveData)
	print("saved")
	saveData = {}
	savefile = null

func cargarPartida():
	reset() #reinicia los stats y otros valores residuales
	#var savefile = FileAccess.open_encrypted_with_pass("savedata.dat",FileAccess.READ,OS.get_unique_id())
	var savefile = FileAccess.open("savedata.dat",FileAccess.READ)
	saveData = savefile.get_var()
	
	if saveData != null:
		await changeScene("res://Scenes/Pantallas/Gremio.tscn")
		#-------------------Preparando saveData para cargar partida----------------------------
		# en este caso las listas de mercenariosContratados y misionesEnCurso se guardaron con el
		# contenido de los diccionarios de los mercenarios contratados y las misiones en curso
		# but en realidad los mercenarios contratados se usan como objetos completos y las misiones
		# en curso solo tiene su ID en SystemStats entonces primero se crean ambos arrays vacios
		# para meter ahi los datos transformados a como se usan en SystemStats y luego se sobreescriben
		# con los de saveData para asi solo sobreescribir de una sola vez el diccionario SystemStats
		# de data con el SystemStats original
		var mercenariosContratados = []
		var misionesEnCurso = []
		
		for mision in saveData.SystemStats.misionesEnCurso: #Se reccorre la lista de diccionarios de misiones en curso
			misionesEnCurso.append(mision.id) 
			buscarMisionPorId(mision.id).stats = mision.duplicate() #Se sobreescribe en la base de datos de las misiones el nuevo diccionario cargado de saveData para la mision correspondiente
		saveData.SystemStats.misionesEnCurso = misionesEnCurso.duplicate()
		
		var i = 0
		for objeto in saveData.SystemStats.objetosTotales:
			objetosTotales[i].stats = objeto
			i+=1
		
		for mercenario in saveData.SystemStats.mercenariosContratados:
			var mercenarioInstance = Mercenario.new(null,null,null,null,null)#Para cargar los mercenarios como estaban antes primero hay que crear mercenarios vaicio y luego se les sobreescriben sus stats
			mercenarioInstance.stats = mercenario.duplicate()#Se sobreescriben las stats del mercenario que se acaba de crear
			mercenariosContratados.append(mercenarioInstance)
		saveData.SystemStats.mercenariosContratados = mercenariosContratados.duplicate()
		#----------------------------------------------------------------------------------------
		
		SystemStats = saveData.SystemStats #Se sobreescribe el diccionario SystemStats con el de saveData
		get_node("/root/Gremio").stats = saveData.GremioStats #se sobreescribe el diccionario de stats del gremio
		GlobalTime.TIME = saveData.GlobalTime# Se sobreescribe el Tiempo Global
		get_tree().get_nodes_in_group("cicloDiaNoche")[0].seek(saveData.GlobalTime.tiempoTranscurrido, true)# actualiza el ciclo de dia y noche
		saveData = {}
		savefile = null
	else:
		pass

#carga las misiones desde el csv
func cargarMisiones():
	misionesTotales = []
#	var file = FileAccess.open_encrypted_with_pass("res://data/misiones.csv", FileAccess.READ,"Konata")
	var file = FileAccess.open("res://data/misiones.txt", FileAccess.READ)
	file.get_line()#sirve para obviar la primera fila del csv
	
	while file.eof_reached() == false:
		var datosMision = Array(file.get_line().split("+"))
		
		var mision = Mision.new(
			datosMision[0].to_int(),
			datosMision[1],
			datosMision[2],
			datosMision[3],
			datosMision[4],
			datosMision[5],
			datosMision[6].to_int(),
			datosMision[7].to_int(),
			datosMision[8].to_int(),
			datosMision[10].to_int(),
			datosMision[11])
			
		misionesTotales.append(mision)
	
	file.close()

#carga los objetos desde el csv
func cargarObjetos():
	objetosTotales = []
	var file = FileAccess.open("res://data/Items.txt", FileAccess.READ)
	file.get_line()# para deshacerse de la primera fila del csv
	
	
	while file.eof_reached() == false:
		var datosObjeto = Array(file.get_line().split("$"))
		
		var objeto = Objeto.new(
			datosObjeto.pop_front(),
			datosObjeto.pop_front(),
			datosObjeto.pop_front(),
			datosObjeto.pop_front(),
			datosObjeto.pop_front(),
			datosObjeto.pop_front(),
			datosObjeto.pop_front(),
			datosObjeto.pop_front(),
			datosObjeto.pop_front(),
			datosObjeto.pop_front(),
			datosObjeto.pop_front(),
			datosObjeto.pop_front(),
			datosObjeto.pop_front(),
			datosObjeto.pop_front(),
			datosObjeto.pop_front(),
			datosObjeto.pop_front(),
			datosObjeto.pop_front(),
			datosObjeto.pop_front(),
			datosObjeto.pop_front(),
			datosObjeto.pop_front(),
			datosObjeto.pop_front(),
			datosObjeto.pop_front(),
			datosObjeto.pop_front(),
		)
		
		objetosTotales.append(objeto)
	
	file.close()

func cargarStats(stats: Dictionary): #carga las stats del diccionario SystemStats
	self.SystemStats = stats

#Organiza las misiones en disponibles o no, 
#teniendo en cuenta las totales, las disponibles y las completadas
func organizarMisiones():
	misionesDisponibles = []
	for mision in misionesTotales:
		if SystemStats.misionesCompletadas.find(mision) == -1 and SystemStats.misionesAceptadas.find(mision.stats.id) == -1:
			misionesDisponibles.append(mision)

#Para generar un mercenario nuevo con estadisticas y nombre segun la formula
func generarMercenarioNuevo():
	var id = generarID()
	var nombre = nombresMercenarios [randi_range(0, nombresMercenarios.size()-1)]
	var rango = randi_range(1,10)
	var ataque = randi_range(10,20)
	var defensa = randi_range(5,10)
	
	return Mercenario.new(id, nombre,rango,ataque,defensa)

func generarID():
	return randi_range(0, 1000000000000000)

#metodo para mostrar la mision nueva que se puede aceptar luego de elegirla
func nuevaMision():
	if misionesDisponibles.size() > 0:
		var index = randi_range(0,misionesDisponibles.size() - 1)
		return misionesDisponibles [index]

#acepta la mision mostrada y la agruega al pozo de misiones aceptadas
func aceptarMision(mision: Mision):
	SystemStats.misionesAceptadas.append(mision.stats.id)
	misionesDisponibles.erase(mision)

#recluta el mercenario enviendolo al pozo de mercenarios contratados
func reclutarMercenario(mercenario:Mercenario):
	SystemStats.mercenariosContratados.append(mercenario)

#Inicia la mision con los mercenarios seleccionados
func iniciarMision(mision:Mision):
	mision.stats.tiempoRestante = mision.stats.duracion
	SystemStats.misionesEnCurso.append(mision.stats.id)
	mision.stats.enCurso = true
	for mercenarioID in mision.stats.mercenariosAsignados:
		var mercenario = buscarMercenarioPorId(mercenarioID)
		mercenario.stats.enMision = true
		SystemStats.mercenariosEnMision.append(mercenario.stats.id)

func cumplirMision(mision: Mision):
	mision.stats.enCurso = false
	SystemStats.misionesEnCurso.erase(mision.stats.id)
	SystemStats.misionesAceptadas.erase(mision.stats.id)
	get_tree().get_nodes_in_group("Gremio")[0].stats.drakmar += mision.stats.drakmar
	
	for mercenarioID in mision.stats.mercenariosAsignados:# se liberan los mercenarios enviados de mision
		SystemStats.mercenariosEnMision.erase(mercenarioID)
		buscarMercenarioPorId(mercenarioID).stats.enMision = false
	
	get_tree().get_nodes_in_group("panelesActivos")[0].mostrarMisionesPanel()
	get_tree().get_nodes_in_group("resultadosDeMision")[0].mostrarMisionCumplida(mision)
	
	for mercenarioID in mision.stats.mercenariosAsignados:#Suma la experiencia de la mision y sube de nivel al mercenario si es necesario
		var mercenario = buscarMercenarioPorId(mercenarioID)
		mercenario.stats.XP += mision.stats.XP
		while mercenario.stats.XP >=100:
			mercenario.stats.XP -= 100
			mercenario.stats.rango += 1
	
	mision.stats.mercenariosAsignados = [] #se vacia el array de mercenarios enviados

func fallarMision(mision:Mision):
	mision.stats.enCurso = false
	SystemStats.misionesEnCurso.erase(mision.stats.id)
	SystemStats.misionesAceptadas.erase(mision.stats.id)
	
	for mercenarioID in mision.stats.mercenariosAsignados: #se liberan los mercenarios que estaban en la mision
		SystemStats.mercenariosEnMision.erase(mercenarioID)
		buscarMercenarioPorId(mercenarioID).stats.enMision = false
	
	mision.stats.mercenariosAsignados = [] # se vacia el array de mercenarios enviados
	
	get_tree().get_nodes_in_group("panelesActivos")[0].mostrarMisionesPanel()
	get_tree().get_nodes_in_group("resultadosDeMision")[0].mostrarMisionFallida()

func adquirirObjeto(objeto, cantidad):
	SystemStats.objetosEnAlmacen.append(objeto.stats.id)
	buscarObjetoPorId(objeto.stats.id).stats.cantidad += cantidad

func retirarObjeto(objeto, cantidad):
	buscarObjetoPorId(objeto.stats.id).stats.cantidad -= cantidad
	purgeAlmacen()

func purgeAlmacen():
	for objetoID in SystemStats.objetosEnAlmacen:
		var objeto = buscarObjetoPorId(objetoID)
		if objeto.stats.cantidad <= 0:
			SystemStats.objetosEnAlmacen.erase(objetoID)

func buscarMisionPorId(id):
	for mision in misionesTotales:
		if mision.stats.id == id:
			return mision
	
	return null

func buscarMercenarioPorId(id):
	for mercenario in SystemStats.mercenariosContratados:
		if mercenario.stats.id == id:
			return mercenario
	
	return null

func buscarObjetoPorId(id):
	for objeto in objetosTotales:
		if objeto.stats.id == id:
			return objeto
	
	return null

func buscarObjetoPorNombre(nombre):
	for objeto in objetosTotales:
		if objeto.stats.nombre == nombre:
			return objeto
	
	return null

func prepararDiccionarioDeGuardado():
	SystemStats.misionesAceptadas.append(arrayToString(SystemStats.misionesAceptadas))

#Convierte un arreglo de objetos en uno de Strings
func arrayToString(arr: Array):
	var result = []
	
	for a in arr:
		result.append(a.guardarDatos())
	
	return result

#Funcion encargada de cargar las escenas y mostrar la pantalla de carga
func changeScene(path):
	get_node("/root/PantallaDeCarga").visible = true
	get_tree().current_scene.queue_free()
	var loader = ResourceLoader.load_threaded_request(path)
	var Scene = ResourceLoader.load_threaded_get(path)
	await get_tree().create_timer(2).timeout
	get_node("/root").add_child(Scene.instantiate())
	get_node("/root/PantallaDeCarga").visible = false

func nuevaPartida():
	reset()
	await changeScene("res://Scenes/Pantallas/Gremio.tscn")
	get_tree().get_nodes_in_group("cinematica")[0].play("inicio")

func pasarDia(): 
	#Se usa para cuando termine el dia y actualizar los dias restantes de las misiones
	get_tree().get_nodes_in_group("cinematica")[0].play("pasarDia")
	GlobalTime.pasarDia()
	for mision in misionesTotales:
		if mision.stats.enCurso and mision.stats.diasRestantes > 0:
			mision.stats.diasRestantes -= 1

func reset():
	GlobalTime.reset()
	objetosTotales = [] # base de datos de los objetos
	misionesDisponibles = [] #base de datos de las misiones disponibles a que un aldeano las presente
	misionesTotales = [] #base de datos con todas las misiones

	SystemStats = { #Diccionario Para los stats del system
	"misionesAceptadas": [], #guarda los ID de las misiones aceptadas
	"misionesCompletadas": [], #guarda los ID de las misiones completadas
	"misionesEnCurso": [], #guarda los ID de las misiones en curso
	
	"objetosEnAlmacen": [], #guarda los ID de los objetos en el Almacen
	
	"mercenariosContratados": [], #guarda los Mercenarios contratados
	"mercenariosEnMision": [] #guarda los ID de los mercenarios en mision
	}
