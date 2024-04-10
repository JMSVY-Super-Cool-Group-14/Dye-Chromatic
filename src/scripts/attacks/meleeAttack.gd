extends Area2D

var lifespan = 0.10
var existenceTime = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	existenceTime += delta
	if existenceTime > lifespan:
		queue_free()


func _on_body_entered(body):
	if body.is_in_group("enemy"):
		print("enemy hit melee!")
		# insert call to enemy.takedamage function

