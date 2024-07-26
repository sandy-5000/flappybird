extends Node

var game_running = false
var game_over = false
var scroll
var score = 0
const SCROLL_SPEED = 4
var screen_size: Vector2i
var ground_height: int
var pipes: Array
const PIPE_DELAY = 100
const PIPE_RANGE = 200


func _ready():
	new_game()

func new_game():
	game_running = false
	game_over = false
	score = 0
	scroll = 0
	$bird.reset()


func _input(event):
	if game_over:
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			if not game_running:
				start_game()
			else:
				if $bird.flying:
					$bird.flap()

func start_game():
	game_running = true
	$bird.flying = true
	$bird.flap()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
