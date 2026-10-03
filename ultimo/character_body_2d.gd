extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var saltando = false
var muerte = false
var velocidad_actual = SPEED

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		saltando=false

	# Handle jump.
	if Input.is_action_just_pressed("arriba") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		saltando=true


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var direction := Input.get_axis("izquierda", "derecha")
	
	if !muerte:
		if direction:
			velocity.x = direction * velocidad_actual
		elif !direction and !saltando:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		velocity.x=0

	
	move_and_slide()
	
	if saltando:
		$AnimatedSprite2D.play("saltar")
	elif direction:
		$AnimatedSprite2D.play("caminar")
		$AnimatedSprite2D.flip_h = direction < 0
	elif muerte:
		$AnimatedSprite2D.play("muerte")
		get_tree().quit()
	else:
		$AnimatedSprite2D.play("idle")


func _on_muerte_body_entered(_body: Node2D) -> void:
	muerte = true
	print("holiwi, te moriste")


func _on_area_2d_body_entered(_body: Node2D) -> void:
	velocidad_actual=velocidad_actual*2


func _on_area_2d_body_exited(_body: Node2D) -> void:
	velocidad_actual=SPEED
