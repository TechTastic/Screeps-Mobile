extends Control

enum Section {
	OFFICIAL,
	COMMUNITY,
	PRIVATE
}

var selected := Section.OFFICIAL

func _ready():
	SwipeDetector.swiped.connect(_on_swipe)
	
	_handle_screen_resize()


func _notification(what):
	if what == NOTIFICATION_RESIZED:
		_handle_screen_resize()


func _handle_screen_resize():
	if !is_portrait():
		for section in $Sections/HBoxContainer.get_children():
			section.show()
	else:
		show_selected()


func show_selected():
	match selected:
		Section.OFFICIAL:
			$Sections/HBoxContainer/OfficialServerSection.show()
			$Sections/HBoxContainer/CommunityServerSection.hide()
			$Sections/HBoxContainer/PrivateServerSection.hide()
		Section.COMMUNITY:
			$Sections/HBoxContainer/OfficialServerSection.hide()
			$Sections/HBoxContainer/CommunityServerSection.show()
			$Sections/HBoxContainer/PrivateServerSection.hide()
		Section.PRIVATE:
			$Sections/HBoxContainer/OfficialServerSection.hide()
			$Sections/HBoxContainer/CommunityServerSection.hide()
			$Sections/HBoxContainer/PrivateServerSection.show()


func _process(_delta):
	if is_portrait():
		show_selected()

func _on_swipe(direction: Vector2):
	#print(direction)
	if direction == Vector2(-1, 0):
		print("Swipe Left!")
	elif direction == Vector2(1, 0):
		print("Swipe Right!")

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
