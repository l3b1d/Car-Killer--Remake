extends Node

const music_stream := preload("res://audio/music/forest.ogg")

var music_player: AudioStreamPlayer

func _ready() -> void:
	var looping_stream := music_stream as AudioStreamOggVorbis
	looping_stream.loop = true
	music_player = AudioStreamPlayer.new()
	music_player.stream = looping_stream
	music_player.bus = &"Music"
	add_child(music_player)
	music_player.play()

func stop_music() -> void:
	if music_player != null:
		music_player.stop()
