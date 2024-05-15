extends MarginContainer


func _ready():
	_handle_screen_resize()

func _notification(what):
	if what == NOTIFICATION_RESIZED:
		_handle_screen_resize()

func _handle_screen_resize():
	print(DisplayServer.screen_get_orientation())
	
	var name = OS.get_name()
	if name == "Android" || name == "iOS":
		var screen_size = get_viewport_rect().size
		var safe_area = DisplayServer.get_display_safe_area()
		var safe_area_top = safe_area.position.y
		var safe_area_sides = safe_area.position.x
		if name == "iOS":
			var screen_scale = DisplayServer.screen_get_scale()
			safe_area_top /= screen_scale
			safe_area_sides /= screen_scale
		if screen_size.x > screen_size.y:
			print("changed to landscape")
			var margin = 0
			add_theme_constant_override("margin_top", margin)
			add_theme_constant_override("margin_right", safe_area_sides + margin)
			add_theme_constant_override("margin_bottom", margin)
			add_theme_constant_override("margin_left", safe_area_sides + margin)
		else:
			print("changed to portrait")
			var margin = 0
			add_theme_constant_override("margin_top", safe_area_top + margin)
			add_theme_constant_override("margin_right", margin / 2)
			add_theme_constant_override("margin_bottom", margin)
			add_theme_constant_override("margin_left", margin / 2)
