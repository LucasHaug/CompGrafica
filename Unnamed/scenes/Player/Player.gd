extends KinematicBody

#export (NodePath) onready var body = self.get_node(body) as Position3D

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


#var has_jumped : bool = false
#var jump_initial_vel : float = 5 # m/s

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	var h_rot : float = $Camroot/h.global_transform.basis.get_euler().y
	
	
	if Input.is_action_pressed("forward") ||  Input.is_action_pressed("backward") ||  Input.is_action_pressed("left") ||  Input.is_action_pressed("right"):
		var input_left : float = Input.get_action_strength("left") - Input.get_action_strength("right")
		var input_forward : float = Input.get_action_strength("forward") - Input.get_action_strength("backward")
		
		# Map from square to circle
		var mapped_left : float = input_left * sqrt(1 - input_forward*input_forward / 2)
		var mapped_forward : float = input_forward * sqrt(1 - input_left*input_left / 2)
		
		direction = Vector3(-mapped_left, 0,-mapped_forward)
		direction = direction.rotated(Vector3.UP, h_rot).normalized()
		
		if Input.is_action_pressed("sprint"): #&& $AnimationTree.get("parameters/aim_transition/current") == 1:
			movement_speed = run_speed
#			$AnimationTree.set("parameters/iwr_blend/blend_amount", lerp($AnimationTree.get("parameters/iwr_blend/blend_amount"), 1, delta * acceleration))
		else:
			movement_speed = walk_speed
#			$AnimationTree.set("parameters/iwr_blend/blend_amount", lerp($AnimationTree.get("parameters/iwr_blend/blend_amount"), 0, delta * acceleration))
	else:
		movement_speed = 0
	
	velocity = lerp(velocity, direction * movement_speed, acceleration * delta)
	
	
	move_and_slide(velocity + Vector3.UP * vertical_velocity, Vector3.UP)
	
	if !self.is_on_floor():
		vertical_velocity += g * delta
	else:
		vertical_velocity = 0

	$Mesh.rotation.y = lerp_angle($Mesh.rotation.y, atan2(-direction.x, -direction.z), angular_acceleration * delta)


#	vel.y += g * delta
#
#	if has_jumped:
#		if self.is_on_floor():
#			vel.y += jump_initial_vel
#		has_jumped = false
#
#	var hv : Vector3 = vel
#	hv.y = 0
#
#	var new_hv : Vector3 = speed * dir.normalized()
#	var actual_acc : float = de_acc
#
#	if dir.dot(hv) > 0:
#		actual_acc = acc
#
#	hv = hv.linear_interpolate(new_hv, actual_acc * delta)
#
#	vel.x = hv.x
#	vel.z = hv.z
#
#
#	vel = self.move_and_slide(vel, Vector3.UP)
	
#	print(actual_vel)

func _input(event):
	pass
#
#	if Input.is_action_just_pressed("jump"):
#		has_jumped = true
