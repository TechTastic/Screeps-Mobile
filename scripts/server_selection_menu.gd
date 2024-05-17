extends Control

enum Section {
	OFFICIAL,
	COMMUNITY,
	PRIVATE
}

var selected := Section.OFFICIAL
const SERVER_SECTION: PackedScene = preload("res://scenes/server_section.tscn")
var sections: Array = []

func _ready():
	if sections.is_empty():
		var official = SERVER_SECTION.instantiate()
		official.section_title = "Official Servers"
		official.is_official = true
		official.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		official.size_flags_vertical = Control.SIZE_EXPAND_FILL
		sections.append(official)
		
		var community = SERVER_SECTION.instantiate()
		community.section_title = "Community Servers"
		community.set_script("res://scripts/CommunityServerSection.gd")
		community.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		community.size_flags_vertical = Control.SIZE_EXPAND_FILL
		sections.append(community)
		
		var private = SERVER_SECTION.instantiate()
		private.section_title = "Private Servers"
		private.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		private.size_flags_vertical = Control.SIZE_EXPAND_FILL
		sections.append(private)
	
	_handle_screen_resize()


func _notification(what):
	if what == NOTIFICATION_RESIZED:
		_handle_screen_resize()


func _handle_screen_resize():
	if is_portrait():
		for index in sections.size():
			var section = sections[index]
			if $Sections/HBoxContainer.get_children().has(section):
				$Sections/HBoxContainer.remove_child(section)
			if !$Sections.get_children().has(section):
				$Sections.add_child(section, index)
			
		
		$Sections/HBoxContainer.hide()
	else:
		$Sections/HBoxContainer.show()
		
		for index in sections.size():
			var section = sections[index]
			if $Sections.get_children().has(section):
				$Sections.remove_child(section)
			if !$Sections/HBoxContainer.get_children().has(section):
				$Sections/HBoxContainer.add_child(section)
			section.show()


func show_selected():
	var section_nodes := $Sections.get_children()
	section_nodes.erase($Sections/HBoxContainer)
	
	if !is_portrait():
		return
	
	for index in section_nodes.size():
		var section := section_nodes[index]
		
		if Section.get(index) == selected:
			section.show()
		else:
			section.hide()


func _process(_delta):
	show_selected()

func _on_swipe(direction: Vector2):
	print(direction)

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


func is_portrait():
	var size = DisplayServer.window_get_size()
	return size.x < size.y
