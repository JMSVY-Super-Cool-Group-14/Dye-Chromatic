extends State
class_name enemyRangeAttack

@export var attack_speed := 3.0
@export var attack_dmg := 2.0

@onready var enemy = $"../.."
@onready var player = $"../../../../Player"
@onready var sm = $".."

var projectile_scene = preload("res://scenes/Enemies/Enemyprojectile.tscn")

var cooldown = false
var timer = null

signal attacking

func fire_projectile():
	if !cooldown:
		attacking.emit()
		print("enemy attack")
		cooldown = true
		get_tree().create_timer(attack_speed).timeout.connect(func(): cooldown = false)
		var projectile = projectile_scene.instantiate()
		add_child(projectile)
		projectile.global_position = enemy.global_position
		projectile.set_direction(player.global_position)
		
func _enter_state():
	enemy.velocity = Vector2.ZERO
	fire_projectile()
	
func _state_update(delta : float):
	fire_projectile()
		
func _state_physics_update(delta : float):
	if player != null:
		var direction = player.global_position - enemy.global_position
		if sm.health <= 0:
			sm._change_state($"../Death")
		
		if direction.length() > 20:
			sm._change_state($"../Chase")

			
	

