extends Node2D

enum View {
	WORLD,
	ROOM
}

@onready var server_selection_menu := $Camera2D/UI/ServerSelectionMenu
@onready var world_view := $WorldView
@onready var room_view := $RoomView

var server: ScreepsServer = null
var rooms := PackedStringArray()
var shard := ""
var room := ""
var view := View.WORLD
var auth_token := ""


func _ready():
	server_selection_menu.server_selected.connect(func(server: ScreepsServer): self.server = server)
	
	if server == null:
		server_selection_menu.show()


func _process(_delta: float):
	if server == null:
		return
	
	if server_selection_menu.visible:
		server_selection_menu.hide()
	
	match view:
		View.WORLD:
			world_view.show()
			room_view.hide()
			_render_world_view()
		View.ROOM:
			world_view.hide()
			room_view.show()
			_render_room_view()


func _render_world_view():
	await ScreepsHTTP.authenticate(server, { "signin": { "email": "", "password": "" } })
	return
	
	ScreepsHTTP.get_room_status(server, "W90N90")
	return
	
	for x in range(-91, 91):
		for y in range(-91, 91):
			var temp := _coord_to_room(x, y)
			
			pass


func _render_room_view():
	pass


func _coord_to_room(x: int, y: int) -> String:
	var room = ""
	if sign(x) == -1:
		room += "E" + str(x + 1)
	else:
		room += "W" + str(x)
	
	if sign(y) == -1:
		room += "S" + str(y + 1)
	else:
		room += "N" + str(y)
	return room
