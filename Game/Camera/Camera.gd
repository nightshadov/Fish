extends Camera

const SPEED = 10
const ROTATIONSPEED = 5


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)



func _physics_process(delta: float) -> void:
	#optimieren?
	var direction = Vector3(0,0,0)
	if Input.is_action_pressed("ui_right"):
		direction += (Vector3(1,0,0))
	if Input.is_action_pressed("ui_left"):
		direction += (Vector3(-1,0,0))
	if Input.is_action_pressed("ui_up"):
		direction += (Vector3(0,0,-1))
	if Input.is_action_pressed("ui_down"):
		direction += (Vector3(0,0,1))
	if Input.is_action_pressed("ui_space"):
		direction += (Vector3(0,1,0))
	if Input.is_action_pressed("ui_faster"):
		direction += (Vector3(0,-1,0))
	if Input.is_action_pressed("ui_quit"):
		get_tree().quit()
		
	translate(direction*delta*SPEED)

func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= deg2rad(event.relative.x* ROTATIONSPEED)
		rotation_degrees.x -= deg2rad(event.relative.y * ROTATIONSPEED)
		
		rotation_degrees.x = clamp(rotation_degrees.x, -90, 90)
