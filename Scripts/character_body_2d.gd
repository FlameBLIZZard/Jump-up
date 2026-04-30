extends CharacterBody2D

# Movement speed (pixels per second)
@export var SPEED := 150.0

# Upward velocity applied when jumping (negative = up in Godot)
@export var JUMP_VELOCITY := -300.0

# Gravity strength (pixels per second squared)
# Using a float instead of Vector2 because gravity should only affect the Y axis
@export var GRAVITY := 1200.0


func _physics_process(delta: float) -> void:
	# Apply gravity only when not on the floor
	# This prevents accumulating downward velocity while airborne
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		# Ensure no residual vertical movement when grounded
		velocity.y = 0

	# Handle jump input
	# Uses "Jump" action (must match Input Map exactly)
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get horizontal input direction (-1 to 1)
	var direction := Input.get_axis("Left", "Right")

	if direction != 0:
		# Immediate horizontal movement when input is present
		velocity.x = direction * SPEED
	else:
		# Hard stop horizontal movement to eliminate all sliding (no deceleration curve)
		velocity.x = 0

	# Move the character using built-in collision handling
	move_and_slide()
