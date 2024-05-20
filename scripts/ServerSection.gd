extends Panel
class_name ServerSection

signal server_selected(server: ScreepsServer)

var server_button: PackedScene = preload("res://scenes/server_button.tscn")
@export var section_title = "Some Servers"
var server_list = []
@onready var server_list_container = $VBoxContainer/ServerScroll/ServerList
@export var is_official: bool = false

func get_official_servers():
	var world = ScreepsServer.new()
	world.server_name = "Screeps: World"
	world.host = "screeps.com"
	
	var seasonal = ScreepsServer.new()
	seasonal.server_name = "Screeps: Seasonal"
	seasonal.host = "screeps.com/seasonal"
	
	return [ world, seasonal ]

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/SectionTitle.text = section_title
	generate_server_list_buttons()

func generate_server_list_buttons():
	print(section_title)
	
	if is_official:
		server_list.append_array(get_official_servers())
	
	for index in server_list.size():
		var server: ScreepsServer = server_list[index]
		var button: ServerButton = server_button.instantiate()
		button.server = server
		server_list_container.add_child(button)
		button.server_selected.connect(func(server: ScreepsServer): server_selected.emit(server))
