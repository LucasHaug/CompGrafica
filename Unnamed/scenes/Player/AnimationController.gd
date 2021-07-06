extends Node

export(NodePath) onready var anim_tree = self.get_node(anim_tree) as AnimationTree

export(NodePath) onready var rest_timer = self.get_node(rest_timer) as Timer
export(NodePath) onready var special_idle_timer = self.get_node(special_idle_timer) as Timer

const MIN_REST_TIME : float = 4.0
const MAX_REST_TIME : float = 10.0
const SPECIAL_IDLE_ANIM_TIME : float = 10.0

const WALK_SCALE : float = 1.0
const RUN_SCALE : float = 1.0

var moving_speed : float = 0

const NUM_OF_SPECIAL_IDLES : int = 4

var special_idles_names : Array = ["happy", "sad", "hip_hop", "searching"]
var special_idles_times : Array = [9, 6, 22, 12]

func _idle_callback():
	GameEvents.emit_play_background()
	
	anim_tree.get("parameters/playback").travel("idle")
	rest_timer.start()


func _walk_callback(mov_speed : float):
	GameEvents.emit_play_background()
	
	_stop_timers()
	moving_speed = mov_speed
	anim_tree.get("parameters/playback").travel("walk")


func _run_callback(mov_speed : float):
	GameEvents.emit_play_background()
	
	_stop_timers()
	anim_tree.get("parameters/playback").travel("run")


func _rest_timer_callback():
	GameEvents.emit_play_background()
	
	anim_tree.get("parameters/idle/playback").travel("rest")
	special_idle_timer.wait_time = _get_random_delay()
	special_idle_timer.start()


func _special_idle_timer_callback():
	var rand_num = randi() % NUM_OF_SPECIAL_IDLES
	
	anim_tree.get("parameters/idle/playback").travel(special_idles_names[rand_num])
		
	special_idle_timer.wait_time = _get_random_delay() + special_idles_times[rand_num]
	special_idle_timer.start()
	
	if rand_num == 2:
		GameEvents.emit_play_dance()
	else:
		GameEvents.emit_play_background()


func _stop_timers():
	special_idle_timer.stop()
	rest_timer.stop()


func _get_random_delay() -> float:
	return MIN_REST_TIME + (MAX_REST_TIME - MIN_REST_TIME) * randf()


func _ready():
	randomize()
	
	var my_player : Spatial = self.get_parent()
	my_player.connect("walk_signal", self, "_walk_callback")
	my_player.connect("run_signal", self, "_run_callback")
	my_player.connect("idle_signal", self, "_idle_callback")
	
	rest_timer.connect("timeout", self, "_rest_timer_callback")
	special_idle_timer.connect("timeout", self, "_special_idle_timer_callback")
	
	rest_timer.start()
