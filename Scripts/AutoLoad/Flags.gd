extends Node

#Para cuando se esten realizando los preparativos de la mision
var preparandoMision: bool = false
var crafteando: bool = false
var vendiendo:bool = false
var mejorando: bool = false
#para cuando se este eligiendo que el equipamineto de un mercenario
var equipandoMercenario: bool = false
var equipandoMercenarioArma: bool = false
var equipandoMercenarioArmadura: bool = false

#--------------------------------
var FLAGS = {
	"NuevaPartida": false,
	"PrimeraMisionDeHistoriaCompletada": false,
}
