extends Node


export(NodePath) onready var background_player = get_node(background_player) as AudioStreamPlayer;
export(NodePath) onready var dance_player = get_node(dance_player) as AudioStreamPlayer;


var _garbage;


func _ready():
	_garbage = GameEvents.connect("play_background", self, "_on_play_background");
	_garbage = GameEvents.connect("play_dance", self, "_on_play_dance");


func _stop_all() -> void:
	background_player.stop();
	dance_player.stop();
	

func _on_play_background() -> void:
	_stop_all();
	background_player.play();
	

func _on_play_dance() -> void:
	_stop_all();
	dance_player.play();
