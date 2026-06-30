extends Node
@onready var camera: Camera2D = $Camera2D

var screen_width: float = 500.0
var current_screen: int = 0

func _ready() -> void:
	$ScreenTransitionTrigger.body_entered.connect(_on_player_crossed)

func _on_player_crossed(body: Node2D) -> void:
	if body is CharacterBody2D:
		var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		body.is_attacking = true
		if current_screen == 0:
			tween.tween_property(camera, "position:x", camera.position.x - screen_width, 0.5)
			current_screen = 1
		else:
			tween.tween_property(camera, "position:x", camera.position.x + screen_width, 0.5)
			current_screen = 0
		await tween.finished
		body.is_attacking = false
