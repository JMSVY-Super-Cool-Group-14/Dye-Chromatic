class_name Trail
extends Line2D

var length = 50
var point = Vector2()
var MAX_POINTS = 20
@onready var curve = Curve2D.new()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	curve.add_point(get_parent().position)
	if curve.get_baked_points().size() > MAX_POINTS:
		curve.remove_point(0)
	points = curve.get_baked_points()

func stop():
	set_process(false)
	var tw = get_tree().create_tween()
	tw.tween_property(self, "modulate:a", 0.0, 0.15)
	await tw.finished
	queue_free()
	
static func create():
	var scn = preload("res://scenes/dodge_trail.tscn")
	return scn.instantiate()
