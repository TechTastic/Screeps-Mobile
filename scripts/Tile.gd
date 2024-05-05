extends Node2D
class_name Tile

signal tile_interacted
signal color_changed(new_color: Color)

@export var color: Color:
	set(value):
		color_changed.emit(value)

func _ready():
	color_changed.connect(_on_color_changed)
	color_changed.emit(color)

func _on_mouse_entered():
	color.lightened(0.5)

func _on_mouse_exited():
	color.darkened(0.5)

func _on_touch_screen_button_pressed():
	tile_interacted.emit()

func _on_color_changed(new_color: Color):
	$ColorRect.color = new_color
