extends Button
class_name ServerButton

signal server_selected(server: ScreepsServer)

@export var server: ScreepsServer = ScreepsServer.new()
@export var connection_style: StyleBoxFlat = StyleBoxFlat.new()
var hover_style: StyleBoxFlat = get_theme_stylebox("theme_override_styles/normal")
var pressed_style: StyleBoxFlat = get_theme_stylebox("theme_override_styles/pressed")
var focus_style: StyleBoxFlat = get_theme_stylebox("theme_override_styles/focus")

func _ready():
	set_label_normal()
	
	$ServerTouchButton.shape.size = self.size
	$ServerTouchButton.pressed.connect(func(): self.pressed.emit())
	$ServerTouchButton.released.connect(func(): self.button_up.emit())
	
	$ConnectionIndicator.add_theme_stylebox_override("fill", set_style_on_ready())
	
	server.server_info_updated.connect(_on_server_info_updated)
	
	server.request_server_info()
	
	_scale_button_height()

func _notification(what: int):
	if what == NOTIFICATION_RESIZED:
		_scale_button_height()

func set_style_on_ready():
	connection_style.corner_radius_bottom_right = 10
	connection_style.corner_radius_top_right = 10
	connection_style.corner_radius_bottom_left = 0
	connection_style.corner_radius_top_left = 0
	connection_style.border_color = Color("000000ab")
	connection_style.border_blend = true
	connection_style.border_width_bottom = 2
	return connection_style

func update_style(online: bool):
	if online:
		connection_style.bg_color = Color(0.0, 1.0, 0.0)
	else:
		connection_style.bg_color = Color(1.0, 0.0, 0.0)
	return connection_style

func _on_pressed():
	server_selected.emit(server)

func get_label_format():
	return "{0}\n{1}"

func set_label_normal():
	text = get_label_format().format([
		server.server_name,
		str(server.users) + " users"
	])
	
	if (server.like_count != -1):
		text += " - " + str(server.like_count) + " likes"

func set_label_hover():
	text = get_label_format().format([
		server.server_name,
		server.host + (
			func():
			var value = ""
			if server.port != "": 
				value += ":" + server.port
			return value
			).call()
	])

func _process(_delta: float):
	if (is_hovered()):
		set_label_hover()
	else:
		set_label_normal()
	
	update_style(server.status == "active")

func _on_server_info_updated(server: ScreepsServer):
	print(JSON.stringify(JSON.parse_string(server.to_json_string()), "    "), "\n")
	self.server = server
	self.queue_redraw()

func _scale_button_height():
	custom_minimum_size.y = size.x / 10
