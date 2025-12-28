extends Node2D

enum MOVE { NONE, ROCK, PAPER, SCISSORS }
enum RESULT { DRAW, WIN, LOSE }

var current_selected_move: int = MOVE.NONE
var opponent_selected_move: int = MOVE.NONE

var choosing: bool
var time_left_to_choose: float

var original_pos_player : Vector2
var original_pos_opponent : Vector2

func _ready() -> void:
	%ROCK_BTN.connect("button_down", func(): select_move(MOVE.ROCK))
	%SCISSORS_BTN.connect("button_down", func(): select_move(MOVE.SCISSORS))
	%PAPER_BTN.connect("button_down", func(): select_move(MOVE.PAPER))
	
	original_pos_player = %Player.position
	original_pos_opponent = %Opponent.position
	
	new_round()
	
func _process(delta: float) -> void:
	time_left_to_choose -= delta
	if choosing && time_left_to_choose < 0:
		choosing = false
		
		match get_result(current_selected_move, opponent_selected_move):
			RESULT.DRAW:
				%ResultLabel.text = "DRAW"
			RESULT.LOSE:
				%ResultLabel.text = "LOSER"
			RESULT.WIN:
				%ResultLabel.text = "WINNER"
				
		await move_back().finished
		new_round()
		
			
func new_round():
	%ResultLabel.text = ""
	pre_move(%Player, Vector2(0,-20)).\
		finished.connect(display_player, Object.CONNECT_ONE_SHOT)
	pre_move(%Opponent, Vector2(0,20)).\
		finished.connect(display_opponent, Object.CONNECT_ONE_SHOT)
	
func move_back() -> Tween:
	var t: Tween = create_tween()
	t.parallel().tween_property(%Player, "position", original_pos_player, 1.0)
	t.parallel().tween_property(%Opponent, "position", original_pos_opponent, 1.0)
	return t

func pre_move(sprite: Sprite2D, movement: Vector2) -> Tween:
	var t: Tween = create_tween()
	
	var from: Vector2 = sprite.position
	var to: Vector2 = sprite.position + movement
	t.tween_property(sprite, "position", to, 0.2)
	t.tween_property(sprite, "position", from, 0.3)
	
	t.tween_property(sprite, "position", to, 0.2)
	t.tween_property(sprite, "position", from, 0.3)
	
	t.tween_property(sprite, "position", to, 0.2)
	return t

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_ESCAPE: get_tree().quit()
			KEY_Q: select_move(MOVE.ROCK)
			KEY_W: select_move(MOVE.PAPER)
			KEY_E: select_move(MOVE.SCISSORS)
	
func select_move(move: MOVE):
	current_selected_move = move
	
	if choosing:
		display_player()
	
func display_player():
	var sprite: Resource = sprite_for_move(current_selected_move)
	%Player.texture = sprite
	
func display_opponent():
	opponent_selected_move = [MOVE.ROCK, MOVE.SCISSORS, MOVE.PAPER].pick_random()
	var sprite: Resource = sprite_for_move(opponent_selected_move)
	%Opponent.texture = sprite
	
	time_left_to_choose = 0.6
	choosing = true
	
func sprite_for_move(move: MOVE) -> Resource:
	match move:
		MOVE.ROCK: return preload("res://assets/rock.png")
		MOVE.PAPER: return preload("res://assets/paper.png")
		MOVE.SCISSORS: return preload("res://assets/scissors.png")
		_: return preload("res://assets/idle.png")

func get_result(a: MOVE, b: MOVE) -> RESULT:
	if a == b:
		return RESULT.DRAW
	if (a == MOVE.SCISSORS and b == MOVE.PAPER)\
		or (a == MOVE.PAPER and b == MOVE.ROCK)\
		or (a == MOVE.ROCK and b == MOVE.SCISSORS):
			return RESULT.WIN
	else:
		return RESULT.LOSE
