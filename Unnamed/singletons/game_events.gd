extends Node


signal play_background;
signal play_dance;


func emit_play_background() -> void:
	self.emit_signal("play_background");


func emit_play_dance() -> void:
	self.emit_signal("play_dance");
