extends Area2D

@onready var boss = $"../Fire Boss"

var damage = 30
var start = false
var hanging = 1
var duration = 4

var orbAmount = 12
var orbVollies = 3
var orbSpeed = 50
var orbDamage = 0
var angle = 2 * PI/orbAmount

var projectile_scene = preload("res://scenes/Enemies/Fire Boss/Attacks/BossHammerProjectile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	print(boss)
	print("enter hammer Scene")
	$CollisionShape2D.disabled = true
	get_tree().create_timer(hanging).timeout.connect(func(): start = true)
	
func _process(delta: float):
	if start:
		start = false
		$AnimationPlayer.play("Falling")

func set_properties(atk_damge):
	damage = atk_damge
		
func _on_area_entered(area):
	if area.is_in_group("player"):
		area.take_fixed_damage(damage)

func spawnOrb(direction):
	var projectile = projectile_scene.instantiate()
	add_child(projectile)
	projectile.global_position = global_position 
	projectile.set_properties(orbSpeed, orbDamage, Vector2(0.5,0.5))
	projectile.set_direction(direction)

func orbVolly():
	while true:
		for y in range(orbAmount):
			var direction = Vector2(cos(y * angle), sin(y * angle))
			spawnOrb(direction)
		await get_tree().create_timer(3).timeout
	await get_tree().create_timer(duration).timeout
	#finished = true

func pick_up():
	queue_free()

func _on_animation_player_animation_finished(anim_name):
	orbVolly()

		
