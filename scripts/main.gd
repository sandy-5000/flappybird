extends Node

@export var pipe_scene: PackedScene

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
	screen_size = get_window().size
	ground_height = $ground.get_node("Sprite2D_part_1").texture.get_height()
	$ground.body_entered.connect(hit_ground)
	$wall.body_entered.connect(hit_wall)
	new_game()

func new_game():
	game_running = false
	game_over = false
	score = 0
	scroll = 0
	pipes.clear()
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
					check_top()

func start_game():
	game_running = true
	$bird.flying = true
	$bird.flap()
	$Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not game_running:
		return
	scroll += SCROLL_SPEED
	if scroll >= screen_size.x:
		scroll = 0
	$ground.position.x = -scroll
	for pipe in pipes:
		pipe.position.x -= SCROLL_SPEED


func _on_timer_timeout():
	generate_pipe()

func generate_pipe():
	var pipe = pipe_scene.instantiate()
	pipe.position.x = screen_size.x + PIPE_DELAY
	pipe.position.y = (screen_size.y - ground_height) / 2 + randi_range(-PIPE_RANGE, PIPE_RANGE)
	pipe.get_node("upper").body_entered.connect(hit_pipe)
	pipe.get_node("lower").body_entered.connect(hit_pipe)
	pipe.get_node("score").body_entered.connect(increase_score)
	add_child(pipe)
	pipes.append(pipe)

func hit_pipe(body):
	if body.name == 'bird':
		stop_game()

func increase_score(body):
	if body.name == 'bird':
		score += 1
		print('score: ', score)

func hit_ground(body):
	if body.name == 'bird':
		stop_game()

func hit_wall(body):
	if body.name == 'score':
		print('pipes hit wall')

func check_top():
	if $bird.position.y < 0:
		stop_game()

func stop_game():
	$bird.falling = true
	$Timer.stop()
	$bird.flying = false
	game_running = false
	game_over = false
