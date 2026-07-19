extends StaticBody2D

signal ability_cooldown(time_left)

#Scriptwide Vars
var win_height : int
var p_height : int
var default_scale : Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	win_height = get_viewport_rect().size.y
	p_height = $ColorRect.get_size().y
	default_scale = scale
	
	

#Custom Functions
func shrink_to_normal_scale_fast():
	if scale > default_scale:
		scale = scale * .9

func bump():
	if $BumpCooldownTimer.is_stopped():
		print("Bump!")
		$BumpCooldownTimer.start()
		scale = scale * 2
		
	
	
func cursor_positioning():
	position.y = get_global_mouse_position().y
	position.y = clamp(position.y, p_height / 2, win_height - p_height /2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	shrink_to_normal_scale_fast()
	
	#Keyboard input
#	if Input.is_action_pressed("move_up"):
#		position.y -= get_parent().PADDLE_SPEED * delta
#	elif Input.is_action_pressed("move_down"):
#		position.y += get_parent().PADDLE_SPEED * delta

	if Input.is_action_just_pressed("bump"):
		bump()
	
	#Mouse/touch controls
	cursor_positioning()
	
	if $BumpCooldownTimer.time_left > 0:
		ability_cooldown.emit(str(roundi($BumpCooldownTimer.time_left)))
	else:
		ability_cooldown.emit(str(""))
		
