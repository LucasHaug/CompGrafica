extends Label


func _ready():
	pass

func _process(delta):
	self.text = 'FPS: ' + str(Engine.get_frames_per_second())
