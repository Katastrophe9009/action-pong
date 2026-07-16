extends Area2D

var win_size : Vector2
var buffed_speed : int
var regular_speed: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#get window size
	win_size = get_viewport_rect().size




func _on_power_up_duration_timer_timeout() -> void:
	$"../Ball".speed -= buffed_speed
	$"../PowerUpTimer".start

func activate():
	regular_speed = $"../Ball".speed
	buffed_speed = $"../Ball".speed * 2
	
	
	$"../PowerUpTimer".stop()
	$"../PowerUpDurationTimer".start()
	$"../Ball".speed = buffed_speed

	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
