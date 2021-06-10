extends Spatial

var camrot_h : float = 0
var camrot_v : float = 0

var mouse_sensitivity_h : float = 0.1
var mouse_sensitivity_v : float = 0.1

var joystick_sensitivity_h : float = 0.43
var joystick_sensitivity_v : float = 0.29

var acceleration_h : float = 10
var acceleration_v : float = 10

var cam_v_max : float = 30
var cam_v_min : float = -55


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$h/v/Camera.add_exception(get_parent())

func _input(event):
	if event is InputEventMouseMotion:
		camrot_h += -event.relative.x * mouse_sensitivity_h
		camrot_v += -event.relative.y * mouse_sensitivity_v
	
#	if event is InputEventJoypadMotion:
#	camrot_h += (Input.get_action_strength("camera_left") - Input.get_action_strength("camera_right")) * joystick_sensitivity_h
#	camrot_v += (Input.get_action_strength("camera_up") - Input.get_action_strength("camera_down")) * joystick_sensitivity_v
	
	if Input.is_action_just_pressed("window_escape"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if Input.is_action_just_pressed("window_focus"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
func _physics_process(delta):
	camrot_h += (Input.get_action_strength("camera_left") - Input.get_action_strength("camera_right")) * joystick_sensitivity_h
	camrot_v += (Input.get_action_strength("camera_up") - Input.get_action_strength("camera_down")) * joystick_sensitivity_v
	
	camrot_v = clamp(camrot_v, cam_v_min, cam_v_max)
	
	$h.rotation_degrees.y = lerp($h.rotation_degrees.y, camrot_h, delta * acceleration_h)
	$h/v.rotation_degrees.x = lerp($h/v.rotation_degrees.x, camrot_v, delta * acceleration_v)
