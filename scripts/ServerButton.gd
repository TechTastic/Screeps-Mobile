extends Button
class_name ServerButton

@export var server_name: String = "Server Name"
@export var host: String = "127.0.0.1"
@export var port: int = -1
@export var version: String = ""

func _ready():
	self.text = server_name + "\n" + host
	if (port != -1):
		self.text += ":" + str(port)
	if (version != ""):
		self.text += " - " + version
	
	$ServerTouchButton.shape.size = self.size
	#$ServerTouchButton.shape.pos = self.position + Vector2(self.size.x / 2, self.size.y / 2)
	$ServerTouchButton.pressed.connect(func(): self.pressed.emit())
	$ServerTouchButton.released.connect(func(): self.button_up.emit())
	
	# TODO: Try Connecting to Server to Test If Online
	var temp = StyleBoxFlat.new()
	temp.corner_radius_bottom_right = 10
	temp.corner_radius_top_right = 10
	temp.corner_radius_bottom_left = 0
	temp.corner_radius_top_left = 0
	temp.border_color = Color("000000ab")
	temp.border_blend = true
	temp.border_width_bottom = 2
	temp.bg_color = Color(0.0, 1.0, 0.0) # Change Color for Online Status
	$ConnectionIndicator.add_theme_stylebox_override("fill", temp)
	$ConnectionIndicator.tooltip_text = "Online"

