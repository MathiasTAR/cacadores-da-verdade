extends CharacterBody2D

@export var SPEED = 100.0

@onready var animation := $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if (!Global.Paused):
		var input_vector = Vector2(
			Input.get_axis("ui_left", "ui_right"),
			Input.get_axis("ui_up", "ui_down")
		)
	
		if input_vector != Vector2.ZERO:
			match input_vector:
				Vector2(1, 0):
					animation.play("Direita")
				Vector2(-1, 0):
					animation.play("Esquerda")
				Vector2(0, 1):
					animation.play("Baixo")
				Vector2(0, -1):
					animation.play("Cima")
				Vector2(1, -1):
					animation.play("Direita_cima")
				Vector2(1, 1):
					animation.play("Direita_baixo")
				Vector2(-1, -1):
					animation.play("Esquerda_cima")
				Vector2(-1, 1):
					animation.play("Esquerda_baixo")
			
			input_vector = input_vector.normalized()
			velocity = input_vector * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.y = move_toward(velocity.y, 0, SPEED)
			animation.play("Idle")
		
		move_and_slide()
