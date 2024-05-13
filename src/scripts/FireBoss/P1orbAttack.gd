extends State
class_name orbAttack



func spawnOrbs():
	var projectile = projectile_scene.instantiate()
	$"../..".add_child(projectile)

func _enter_state():
	spawnOrbs()

func fire_projectile():
	if !cooldown:
		attacking.emit()
		cooldown = true
		get_tree().create_timer(attack_speed).timeout.connect(func(): cooldown = false)
		var projectile = projectile_scene.instantiate()
		$"../..".add_child(projectile)
		
		projectile.global_position = enemy.global_position
		var direction = player.global_position - enemy.global_position
		projectile.set_direction(direction)

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
