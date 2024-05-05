extends Button
class_name ServerButton

@export var server: ScreepsServer = ScreepsServer.new()
@export var connection_style: StyleBoxFlat = StyleBoxFlat.new()

func _ready():
	set_label_normal()
	
	$ServerTouchButton.shape.size = self.size
	$ServerTouchButton.pressed.connect(func(): self.pressed.emit())
	$ServerTouchButton.released.connect(func(): self.button_up.emit())
	
	$ConnectionIndicator.add_theme_stylebox_override("fill", set_style_on_ready())
	
	server.server_info_updated.connect(_on_server_info_updated)
	
	server.request_server_info()

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
	print(server.to_json_string())
	print(ScreepsHTTP.get_http_url(server))
	# Attempt to Connect
	# Is auth'd? If not, auth
	# Render Game
	print("Connecting to " + server.server_name)

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

func _process(_delta):
	if (is_hovered()):
		set_label_hover()
	else:
		set_label_normal()
	
	update_style(server.status == "active")

func _on_server_info_updated(server: ScreepsServer):
	self.server = server
	self.queue_redraw()
