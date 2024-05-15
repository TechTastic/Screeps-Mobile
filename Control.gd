extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	print(OS.get_name())
	print(OS.get_model_name())
	DisplayServer.FEATURE_SUBWINDOWS
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
