extends Polygon2D

var dragging := false
var origin := Vector2(90,90)
var stretch_to := Vector2(90,90)
var current_tween  # <- No type here to avoid the error

func _ready():
	stretch_to = origin
	_update_polygon()
	set_process_input(true)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			# Stop current tween if dragging again
			if current_tween:
				current_tween.kill()
		else:
			dragging = false
			# Snap back to origin
			current_tween = create_tween()
			current_tween.tween_property(self, "stretch_to", origin, 0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)

	elif event is InputEventMouseMotion and dragging:
		stretch_to = event.position
		_update_polygon()

func _process(_delta):
	_update_polygon()

func _update_polygon():
	var thickness := 50
	var dir := (stretch_to - origin)
	if dir.length() == 0:
		dir = Vector2.RIGHT
	dir = dir.normalized()
	var perp := Vector2(-dir.y, dir.x) * thickness / 2.0

	polygon = [
		origin + perp,
		origin - perp,
		stretch_to - perp,
		stretch_to + perp,
	]
