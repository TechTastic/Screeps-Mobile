extends Node

signal swiped(direction: Vector2)
signal swipe_canceled(start_position: Vector2)

@export_range(1.0, 1.5) var MAX_DIAGONAL_SLOPE := 1.3

@onready var timer := $Timer
var swipe_start_position: Vector2

func _input(event: InputEvent):
	if not event is InputEventScreenTouch:
		return
	
	if event.pressed:
		_start_detection(event.position)
	elif not timer.is_stopped():
		_end_detection(event.position)

func _start_detection(position: Vector2):
	swipe_start_position = position
	timer.start()

func _end_detection(position: Vector2):
	timer.stop()
	var direction := (position - swipe_start_position).normalized()
	if abs(direction.x) + abs(direction.y) >= MAX_DIAGONAL_SLOPE:
		return
	
	if abs(direction.x) > abs(direction.y):
		# Horizontal Swipe
		swiped.emit(Vector2(-sign(direction.x), 0.0))
	else:
		# Vertical Swipe
		swiped.emit(Vector2(0.0, -sign(direction.y)))

func _on_timer_timeout():
	swipe_canceled.emit(swipe_start_position)
