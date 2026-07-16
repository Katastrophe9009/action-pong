extends StaticBody2D


var win_height : int
var p_height : int
var default_scale : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	win_height = get_viewport_rect().size.y
	p_height = $ColorRect.get_size().y
	default_scale = scale



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	if scale > default_scale:
		scale = scale * .9
	
#	if Input.is_action_pressed("move_up"):
#		position.y -= get_parent().PADDLE_SPEED * delta
#	elif Input.is_action_pressed("move_down"):
#		position.y += get_parent().PADDLE_SPEED * delta



	if Input.is_action_just_pressed("bump") and $"../BumpCooldownTimer".is_stopped():
		print("Bump!")
		$"../BumpCooldownTimer".start()
		scale = scale * 2

	position.y = get_global_mouse_position().y
	position.y = clamp(position.y, p_height / 2, win_height - p_height /2)
