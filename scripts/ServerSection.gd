extends Panel
class_name ServerSection

var server_button: PackedScene = preload("res://scenes/server_button.tscn")
@export var section_title = "Some Servers"
@export var server_list = []
@onready var server_list_container = $VBoxContainer/ServerScroll/ServerList

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/SectionTitle.text = section_title
	generate_server_list_buttons()

func generate_server_list_buttons():
	print(section_title)
	print(server_list)
	for index in server_list.size():
		var server = server_list[index]
		var button: ServerButton = server_button.instantiate()
		if server is ScreepsServer:
			button.server = server
		elif server is Dictionary:
			button.server.set_server_properties(server.name, server.host, server.get("port", -1), server.get("version", ""))
		server_list_container.add_child(button)
