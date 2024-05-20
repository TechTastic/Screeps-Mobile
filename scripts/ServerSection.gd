extends Panel
class_name ServerSection

signal server_selected(server: ScreepsServer)

var server_button: PackedScene = preload("res://scenes/server_button.tscn")
@export var section_title := "Some Servers"
var server_list: Array[ScreepsServer] = []
@onready var server_list_container := $VBoxContainer/ServerScroll/ServerList


func _ready():
	$VBoxContainer/SectionTitle.text = section_title


func generate_server_list_buttons():
	for server in server_list:
		var button: ServerButton = server_button.instantiate()
		button._on_server_info_updated(server)
		server_list_container.add_child(button)
		button.server_selected.connect(func(selected_server: ScreepsServer): server_selected.emit(selected_server))
