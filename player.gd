extends CharacterBody2D
@export var speed: float = 150.0

@export var texture_down: Texture2D
@export var texture_up: Texture2D
@export var texture_left: Texture2D
@export var texture_right: Texture2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var weapon_area: Area2D = $WeaponArea

var facing_direction: String = "up"
var is_attacking: bool = false

func _physics_process(_delta: float) -> void:
	if is_attacking:
		return
	
	var input_vector: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_vector != Vector2.ZERO:
		velocity = input_vector * speed
		update_direction(input_vector)
	else:
		velocity = Vector2.ZERO
		
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and not is_attacking:
		attack()

func update_direction(input: Vector2) -> void:
	if abs(input.x) > abs(input.y):
		if input.x > 0:
			facing_direction = "right"
			sprite.texture = texture_right
		else:
			facing_direction = "left"
			sprite.texture = texture_left
	else:
		if input.y > 0:
			facing_direction = "down"
			sprite.texture = texture_down
		else:
			facing_direction = "up"
			sprite.texture = texture_up

func attack() -> void:
	is_attacking = true
	velocity = Vector2.ZERO
	
	match facing_direction:
		"up":
			weapon_area.rotation = 0.0
		"right":
			weapon_area.rotation = PI / 2
		"down":
			weapon_area.rotation = PI
		"left":
			weapon_area.rotation = -PI / 2
	
	weapon_area.show()
	await get_tree().create_timer(0.15).timeout
	weapon_area.hide()
	is_attacking = false
	
