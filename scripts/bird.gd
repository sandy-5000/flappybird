extends CharacterBody2D

const GRAVITY = 1000
const MAX_VEL = 600
const FLAP_SPEED = -500
var flying = false
var falling = false
const START_POS = Vector2(243, 432)

func _ready():
	reset()

func reset():
	falling = false
	flying = false
	position = START_POS
	rotation = 0


func _physics_process(delta):
	if not flying and not falling:
		$AnimatedSprite2D.stop()
		return
	velocity.y += GRAVITY * delta
	if velocity.y > MAX_VEL:
		velocity.y = MAX_VEL
	if flying:
		rotation = deg_to_rad(velocity.y * 0.05)
		$AnimatedSprite2D.play("flying")
	elif falling:
		rotation = PI / 2
		$AnimatedSprite2D.stop()
	move_and_collide(velocity * delta)

func flap():
	velocity.y = FLAP_SPEED

