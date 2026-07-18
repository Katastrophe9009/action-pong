extends Area2D

var win_size : Vector2
var buffed_speed : int
var regular_speed: int
var random_move_range: int
var target_pos : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#get window size
	win_size = get_viewport_rect().size




func _on_power_up_duration_timer_timeout() -> void:
	$"../Ball".speed -= buffed_speed
	$"../PowerUpTimer".start

func activate(target_ball):
	target_ball.speed = target_ball.speed * 2
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
#	random_move_range = randi_range(10,50)
#	target_pos = Vector2(random_move_range, random_move_range)
#	position.x += random_move_range
#	position.y += random_move_range
#	position.x -= random_move_range
#	position.y -= random_move_range

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("ball"):
		activate(body)
