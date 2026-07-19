extends CharacterBody2D

signal point_scored(side)

@export var trail_color: Color
@export var trail_length: int = 20
@export var trail_width: int = 5
@export var trail_curve_min_width: float = 0.0
@export var trail_curve_max_width: float = 0.5
@export var start_speed : int = 500
@export var accel : int = 50
@export var speed : int
@export var dir : Vector2


const MAX_Y_VECTOR : float = 0.6

var win_size : Vector2


func _ready() -> void:
	
	#Obtain the window's size.
	win_size = get_viewport_rect().size
	
	speed = start_speed
	dir = random_direction()
	
	#Set the color of the ball's trail to the desired color.
	$Line2D.default_color = trail_color
	$Line2D.width = trail_width
	
	
func new_ball():

	speed = start_speed
	dir = random_direction()
	
func generate_trail():
#	print("Current Ball Speed/Velocity:", speed)
	if speed > 0:
		$Line2D.add_point(global_position)
		if $Line2D.get_point_count() > trail_length:
			$Line2D.remove_point(0)
			
	
func _physics_process(delta: float) -> void:
	var collision = move_and_collide(dir * speed * delta)
	var collider
	
	generate_trail()
	
	if collision:
		collider = collision.get_collider()
		
		$"../ScreenShakeTimer".start()

			
		if collider == $"../Player":
			if $"../Player".scale > $"../Player".default_scale:
				speed += accel * 10
			else:
				speed += accel
			dir = new_direction(collider)
		elif collider == $"../CPU":
			speed += accel
			dir = new_direction(collider)
			
		else:
			dir = dir.bounce(collision.get_normal())
	
func random_direction():
	var new_dir := Vector2()
	new_dir.x = [1, -1].pick_random()
	new_dir.y = randf_range(-1, 1)
	return new_dir.normalized()

func new_direction(collider):
	var ball_y = position.y
	var pad_y = collider.position.y
	var dist = ball_y - pad_y
	var new_dir := Vector2()
	
	if dir.x > 0:
		new_dir.x = -1
	else:
		new_dir.x = 1
	new_dir.y = (dist / (collider.p_height / 2)) * MAX_Y_VECTOR
	return new_dir.normalized()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("left_goal"):
		print("Goal Passed: ", area)
		point_scored.emit("left")
		
		pass
	elif area.is_in_group("right_goal"):
		print("Goal Passed: ", area)
		point_scored.emit("right")
	queue_free()
