extends Sprite2D

@export var powerups : Array[PackedScene]
@export var ball_scene: PackedScene



var score := [0, 0]# 0:Player, 1:CPU
var win_size : Vector2

const PADDLE_SPEED : int = 500

func _ready() -> void:
	#get window size
	win_size = get_viewport_rect().size
	print("Window Size:", win_size)

func _on_screen_shake_timer_timeout() -> void:
	$Camera2D.offset = Vector2(0,0)

func _on_ball_timer_timeout() -> void:
	
	spawn_ball()

func clear_powerups():
	var active_powerups = get_tree().get_nodes_in_group("powerups")
	for powerup in active_powerups:
		powerup.queue_free()

func reset_powerups():
	print("Resetting Powerups...")
	$PowerUpDurationTimer.stop()
	$PowerUpTimer.start()
	clear_powerups()

func spawn_ball():
	
	var spawning_ball = ball_scene.instantiate()
	spawning_ball.add_to_group("ball")
	spawning_ball.position.x = win_size.x /2
	spawning_ball.position.y = randi_range(200, win_size.y -200)
	add_child(spawning_ball)

	
	pass

func clear_balls():
#	for ball is_in_group("ball"):
#		ball.queue_free()

	pass

func spawn_powerup():
	#Pick and define a random powerup to spawn.
	print("Spawning a Random Powerup...")
	var spawning_powerup = powerups.pick_random().instantiate()
	
	#Position the powerup randomly somewhere in the playing field and spawn it.
	spawning_powerup.position.x = randi_range(200, win_size.x -200)
	spawning_powerup.position.y = randi_range(200, win_size.y -200)
	add_child(spawning_powerup)
	print("Spawned:", spawning_powerup)
	


func _on_power_up_timer_timeout() -> void:
	
	clear_powerups()
	spawn_powerup()

func reinitialize():
	print("Starting New Round...")

	$BallTimer.start()
	$PowerUpDurationTimer.stop()
	$PowerUpTimer.start()
	$BumpCooldownTimer.stop()
	reset_powerups()

func _on_score_left_body_entered(body: Node2D) -> void:
	var score_tween = create_tween()
	
	print("Opponent Scores...")
	score[1] += 1
	
	#Hud "Pop"
	$Hud/CPUScore.text = str(score[1])
	score_tween.tween_property($Hud/CPUScore, "scale", Vector2(1.5, 1.5), 0.1).set_trans(Tween.TRANS_ELASTIC)
	score_tween.tween_property($Hud/CPUScore, "scale", Vector2(1, 1), 0.1).set_trans(Tween.TRANS_ELASTIC)
	
	print("Opponent Points: ", score[1])
	reinitialize()

func _on_score_right_body_entered(body: Node2D) -> void:
	var score_tween = create_tween()
	
	print("Player Scores...")
	score[0] += 1
	
	#Hud "Pop"
	$Hud/PlayerScore.text = str(score[0])
	score_tween.tween_property($Hud/PlayerScore, "scale", Vector2(1.5, 1.5), 0.1).set_trans(Tween.TRANS_ELASTIC)
	score_tween.tween_property($Hud/PlayerScore, "scale", Vector2(1, 1), 0.1).set_trans(Tween.TRANS_ELASTIC)
	
	print("Player Points: ", score[0])
	reinitialize()

func _process(delta: float) -> void:
	if $BumpCooldownTimer.time_left > 0:
		$Hud/BumpCooldown.text = str(roundi($BumpCooldownTimer.time_left))
	else:
		$Hud/BumpCooldown.text = str("")
		
	if $ScreenShakeTimer.time_left > 0:
		$Camera2D.offset = Vector2(randi_range(-5,5) * ($ScreenShakeTimer.time_left *2),randi_range(-5,5) * ($ScreenShakeTimer.time_left *2))
		
