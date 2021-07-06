extends Node


export(NodePath) onready var background_player = get_node(background_player) as AudioStreamPlayer;
export(NodePath) onready var dance_player = get_node(dance_player) as AudioStreamPlayer;


var _garbage;


func _ready():
	_garbage = GameEvents.connect("play_dance", self, "_on_play_dance");
	_garbage = GameEvents.connect("play_background", self, "_on_play_background");
	_garbage = dance_player.connect("finished", self, "_on_play_background");
	

func _on_play_background() -> void:
	if dance_player.is_playing():
		dance_player.stop()
	
	if background_player.get_stream_paused():
		background_player.set_stream_paused(false);
	

func _on_play_dance() -> void:
	background_player.set_stream_paused(true);
	dance_player.play();
