extends RigidBody2D

export var max_speed = 400.0
export var min_speed = 100.0
onready var HUD = get_node("/root/Game/HUD")
onready var camera = get_node("/root/Game/Camera")

var trauma = 0.01

func _ready():
	HUD.connect("changed",self,"_on_HUD_changed")
	contact_monitor = true
	set_max_contacts_reported(4)
	update_color()


func update_color():
	if HUD.color_ball:
		$Color.color = Color8(34,184,207)
	else:
		$Color.color = Color(1,1,1,1)
	if HUD.particle_ball:
		$Particles2D.emitting = true
	else:
		$Particles2D.emitting = false




func _on_HUD_changed():
	update_color()	

func _physics_process(_delta):
	var bodies = get_colliding_bodies()
	for body in bodies:
		if body.name == "Walls":
			if HUD.screen_shake_walls > 0:
				camera.add_trauma(trauma*HUD.screen_shake_walls)
		if body.name == "Paddle":
			if HUD.screen_shake_paddle > 0:
				camera.add_trauma(trauma*HUD.screen_shake_paddle)
		if body.is_in_group("Brick"):
			if HUD.screen_shake_blocks > 0:
				camera.add_trauma(trauma*HUD.screen_shake_blocks)


	
		if body.has_method("emit_particle"):
			body.emit_particle(global_position)
		if body.is_in_group("Brick"):
			body.die()





func _integrate_forces(state):
	if abs(state.linear_velocity.x) < min_speed:
		state.linear_velocity.x = sign(state.linear_velocity.x) * min_speed
	if abs(state.linear_velocity.y) < min_speed:
		state.linear_velocity.y = sign(state.linear_velocity.y) * min_speed
	if state.linear_velocity.length() > max_speed:
		state.linear_velocity = state.linear_velocity.normalized() * max_speed
