extends Polygon2D

var dragging := false
var origin := Vector2(100, 100)  # Left side stays fixed
var stretch_to := Vector2(300, 100)  # Right side moves

func _ready():
	_update_polygon()

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		dragging = event.pressed
		if dragging:
			stretch_to = event.position
			_update_polygon()

	elif event is InputEventMouseMotion and dragging:
		stretch_to = event.position
		_update_polygon()

func _update_polygon():
	# Define a quad between origin and stretch_to
	var thickness := 50
	var dir := (stretch_to - origin).normalized()
	var perp := Vector2(-dir.y, dir.x) * thickness / 2.0

	# Build quad as a polygon
	polygon = [
		origin + perp,
		origin - perp,
		stretch_to - perp,
		stretch_to + perp,
	]
