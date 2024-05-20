extends Node2D

enum View {
	WORLD,
	ROOM
}

@onready var server_selection_menu = $Camera2D/UI/ServerSelectionMenu
var server: ScreepsServer = null
var room: String = ""

func _ready():
	server_selection_menu.server_selected.connect(func(server: ScreepsServer): self.server = server)
	
	if server == null:
		server_selection_menu.show()

func _process(_delta):
	if server == null:
		return
	
	if server_selection_menu.visible:
		server_selection_menu.hide()
