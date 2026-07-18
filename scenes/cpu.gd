extends StaticBody2D

var ball_pos : Vector2
var dist : int
var move_by : int
var win_height : int
var p_height : int
var balls_in_play : Array


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	win_height = get_viewport_rect().size.y
	p_height = $ColorRect.get_size().y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	balls_in_play = get_tree().get_nodes_in_group("ball")


	if not balls_in_play.is_empty():
		ball_pos = balls_in_play[0].position
		dist = position.y - ball_pos.y
	
		if abs(dist) > get_parent().PADDLE_SPEED * delta:
			move_by = (get_parent().PADDLE_SPEED + get_parent().score[0]) * delta * (dist / abs(dist))
		else:
			move_by = dist
	
		position.y -= move_by
	
		position.y = clamp(position.y, p_height / 2, win_height - p_height /2)
