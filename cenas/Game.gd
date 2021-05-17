extends Node2D


func _ready():
	pass


func _on_Jogador1_perdeuPartida():
	$AudioPlaying.stop()


func _on_Jogador2_perdeuPartida():
	$AudioPlaying.stop()
