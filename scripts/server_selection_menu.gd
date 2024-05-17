extends Control

enum Section {
	OFFICIAL,
	COMMUNITY,
	PRIVATE
}

var selected = Section.OFFICIAL

func _ready():
	_handle_screen_resize()


func _notification(what):
	if what == NOTIFICATION_RESIZED:
		_handle_screen_resize()


func _handle_screen_resize():
	if is_portrait():
		pass
	else:
		pass


func show_selected():
	if !is_portrait():
		return
	match selected:
		Section.OFFICIAL:
			pass
		Section.COMMUNITY:
			pass
		Section.PRIVATE:
			pass


func _input(event):
	if event is InputEventScreenDrag:
		print("Tilt:", event.tilt)
		print("Velocity:", event.velocity)
		print(event.is_pressed())
		print(event.is_released())


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
