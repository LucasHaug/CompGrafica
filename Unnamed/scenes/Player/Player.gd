extends KinematicBody

export(NodePath) onready var visual = self.get_node(visual) as Spatial
export(NodePath) onready var camroot = self.get_node(camroot) as Spatial

const g : float = -20.0 # m/s²

var velocity : Vector3 = Vector3.ZERO
var vertical_velocity : float = 0

var direction : Vector3 = Vector3.FORWARD # m/s

var movement_speed : float = 0 # m/s
var walk_speed : float = 2.5 # m/s
var run_speed : float = 5 # m/s
var acceleration : float = 6 # m/s²
#var de_acc : float = 5 # m/s²
var angular_acceleration : float = 7 # º/s²


enum anim_signals {
	WALK,
	RUN,
	IDLE
}

var cur_signal : int = anim_signals.IDLE
var cur_mov_speed : float = 0

signal walk_signal(mov_speed)
signal run_signal(mov_speed)
signal idle_signal()


func _physics_process(delta):
	
	var h_rot : float = camroot.get_child(0).global_transform.basis.get_euler().y
	
	if Input.is_action_pressed("forward") or Input.is_action_pressed("backward") or Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		var input_left : float = Input.get_action_strength("left") - Input.get_action_strength("right")
		var input_forward : float = Input.get_action_strength("forward") - Input.get_action_strength("backward")
		var walk_multiplier : float = 1
		
		direction = Vector3(-input_left, 0,-input_forward)
		
		if direction.length_squared() < 0.3:
			walk_multiplier = 0.5
		
		direction = direction.rotated(Vector3.UP, h_rot).normalized()
			
		if Input.is_action_pressed("sprint"):
			movement_speed = run_speed
			
			if cur_signal != anim_signals.RUN:
				self.emit_signal("run_signal", movement_speed)
				cur_signal = anim_signals.RUN
		else:
			movement_speed = walk_speed * walk_multiplier
			
			if cur_signal != anim_signals.WALK or cur_mov_speed != movement_speed:
				self.emit_signal("walk_signal", movement_speed)
				cur_signal = anim_signals.WALK
				cur_mov_speed = movement_speed
	else:
		movement_speed = 0
		
		if cur_signal != anim_signals.IDLE:
			self.emit_signal("idle_signal")
			cur_signal = anim_signals.IDLE
	
	velocity = lerp(velocity, direction * movement_speed, acceleration * delta)
	
	move_and_slide(velocity + Vector3.UP * vertical_velocity, Vector3.UP)
	
	if !self.is_on_floor():
		vertical_velocity += g * delta
	else:
		vertical_velocity = 0

	visual.rotation.y = lerp_angle(visual.rotation.y, atan2(-direction.x, -direction.z), angular_acceleration * delta)
