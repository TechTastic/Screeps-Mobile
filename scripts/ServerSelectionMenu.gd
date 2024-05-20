extends Control

signal server_selected(server: ScreepsServer)

enum Section {
	OFFICIAL,
	COMMUNITY,
	PRIVATE
}

var selected := Section.OFFICIAL
@onready var official_server_section = $Sections/HBoxContainer/OfficialServerSection
@onready var community_server_section = $Sections/HBoxContainer/CommunityServerSection
@onready var private_server_section = $Sections/HBoxContainer/PrivateServerSection


func _ready():
	official_server_section.server_list.append_array(ScreepsAPI.official_server_list)
	official_server_section.generate_server_list_buttons()
	
	await ScreepsAPI.community_servers_updated
	community_server_section.server_list.append_array(ScreepsAPI.community_server_list)
	community_server_section.generate_server_list_buttons()
	
	private_server_section.server_list.append_array(ScreepsAPI.private_server_list)
	private_server_section.generate_server_list_buttons()
	
	SwipeDetector.swiped.connect(_on_swipe)
	
	official_server_section.server_selected.connect(_on_server_selected)
	community_server_section.server_selected.connect(_on_server_selected)
	private_server_section.server_selected.connect(_on_server_selected)
	
	_handle_screen_resize()


func _notification(what: int):
	if what == Control.NOTIFICATION_RESIZED:
		_handle_screen_resize()


func _handle_screen_resize():
	if !_is_portrait():
		for section in $Sections/HBoxContainer.get_children():
			section.show()
	else:
		_show_selected()


func _show_selected():
	match selected:
		Section.OFFICIAL:
			official_server_section.show()
			community_server_section.hide()
			private_server_section.hide()
		Section.COMMUNITY:
			official_server_section.hide()
			community_server_section.show()
			private_server_section.hide()
		Section.PRIVATE:
			official_server_section.hide()
			community_server_section.hide()
			private_server_section.show()


func _process(_delta: float):
	if _is_portrait():
		_show_selected()


func _on_swipe(direction: Vector2):
	if _is_portrait():
		if direction == Vector2(-1, 0):
			_on_left_swipe()
		elif direction == Vector2(1, 0):
			_on_right_swipe()


func _on_left_swipe():
	match selected:
		Section.OFFICIAL:
			selected = Section.PRIVATE
		Section.COMMUNITY:
			selected = Section.OFFICIAL
		Section.PRIVATE:
			selected = Section.COMMUNITY


func _on_right_swipe():
	match selected:
		Section.OFFICIAL:
			selected = Section.COMMUNITY
		Section.COMMUNITY:
			selected = Section.PRIVATE
		Section.PRIVATE:
			selected = Section.OFFICIAL

func _on_server_selected(server: ScreepsServer):
	server_selected.emit(server)

func _is_portrait():
	var size = DisplayServer.window_get_size()
	return size.x < size.y
