extends Control

enum Section {
	OFFICIAL,
	COMMUNITY,
	PRIVATE
}

var selected = Section.OFFICIAL
const SERVER_SECTION_CHANGE_BUTTON = preload("res://scenes/server_section_change_button.tscn")

func _ready():
	$ServerSectionsContainer/HBoxContainer/LeftButton.pressed.connect(_on_left_button)
	$ServerSectionsContainer/HBoxContainer/RightButton.pressed.connect(_on_right_button)
	_handle_screen_resize()


func _notification(what):
	if what == NOTIFICATION_RESIZED:
		_handle_screen_resize()


func _handle_screen_resize():
	if is_portrait():
		$ServerSectionsContainer/HBoxContainer/LeftButton.show()
		$ServerSectionsContainer/HBoxContainer/RightButton.show()
		
		show_selected()
	else:
		$ServerSectionsContainer/HBoxContainer/LeftButton.hide()
		$ServerSectionsContainer/HBoxContainer/RightButton.hide()
		
		$ServerSectionsContainer/HBoxContainer/OfficialServerSection.show()
		$ServerSectionsContainer/HBoxContainer/CommunityServerSection.show()
		$ServerSectionsContainer/HBoxContainer/PrivateServerSection.show()


func show_selected():
	if !is_portrait():
		return
	match selected:
		Section.OFFICIAL:
			$ServerSectionsContainer/HBoxContainer/OfficialServerSection.show()
			$ServerSectionsContainer/HBoxContainer/CommunityServerSection.hide()
			$ServerSectionsContainer/HBoxContainer/PrivateServerSection.hide()
		Section.COMMUNITY:
			$ServerSectionsContainer/HBoxContainer/OfficialServerSection.hide()
			$ServerSectionsContainer/HBoxContainer/CommunityServerSection.show()
			$ServerSectionsContainer/HBoxContainer/PrivateServerSection.hide()
		Section.PRIVATE:
			$ServerSectionsContainer/HBoxContainer/OfficialServerSection.hide()
			$ServerSectionsContainer/HBoxContainer/CommunityServerSection.hide()
			$ServerSectionsContainer/HBoxContainer/PrivateServerSection.show()


func _process(_delta):
	show_selected()


func _on_left_button():
	match selected:
		Section.OFFICIAL:
			selected = Section.PRIVATE
		Section.COMMUNITY:
			selected = Section.OFFICIAL
		Section.PRIVATE:
			selected = Section.COMMUNITY


func _on_right_button():
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
