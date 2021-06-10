extends Node

export(NodePath) onready var anim_tree = self.get_node(anim_tree) as AnimationTree

const WALK_SCALE : float = 1.0
const RUN_SCALE : float = 1.0

var iwr_blend_setpoint : float = -1 # starts at idle
var moving_speed : float = 0

func _idle_callback():
	iwr_blend_setpoint = -1
	anim_tree.get("parameters/playback").travel("idle")


func _walk_callback(mov_speed : float):
	iwr_blend_setpoint = 0
	moving_speed = mov_speed
	anim_tree.get("parameters/playback").travel("walk")


func _run_callback(mov_speed : float):
	iwr_blend_setpoint = 1
	anim_tree.get("parameters/playback").travel("run")


func _ready():
	var my_player : Spatial = self.get_parent()
	my_player.connect("walk_signal", self, "_walk_callback")
	my_player.connect("run_signal", self, "_run_callback")
	my_player.connect("idle_signal", self, "_idle_callback")

func _physics_process(delta):
	pass
#	var actual_iwr_blend : float = anim_tree.get("parameters/iwr_blend/blend_amount")
#	anim_tree.set("parameters/iwr_blend/blend_amount", lerp(actual_iwr_blend, iwr_blend_setpoint, delta * 5))
