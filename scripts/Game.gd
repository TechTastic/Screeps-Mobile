extends Node2D

enum View {
	WORLD,
	ROOM
}

@onready var server_selection_menu := $Camera2D/UI/ServerSelectionMenu
@onready var world_view := $WorldView
@onready var room_view := $RoomView

var server: ScreepsServer = null
var shard: String = ""
var room: String = ""
var view := View.WORLD

func _ready():
	server_selection_menu.server_selected.connect(func(server: ScreepsServer): self.server = server)
	
	if server == null:
		server_selection_menu.show()

func _process(_delta):
	if server == null:
		return
	
	if server_selection_menu.visible:
		server_selection_menu.hide()
	
	match view:
		View.WORLD:
			world_view.show()
			room_view.hide()
		View.ROOM:
			world_view.hide()
			room_view.show()
