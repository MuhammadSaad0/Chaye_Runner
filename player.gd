extends CharacterBody3D

var SPEED = 50.0
var JUMP_VELOCITY = 8.5
var dead = 0
var lane = 1
var score_label
var coin_label
var score = 0
var coins = 0
var jumpBoostTimer = 0
var speedBoostTimer = 0
var paanTimer = 0
var camPos
signal changeTerrainSpeed(val)

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func change_lane(change):
	lane += change;
	if lane > 2:
		lane = 2
	if lane < 0:
		lane = 0
	
func _ready():
	score_label = get_parent_node_3d().get_node('UserInterface/Score')
	coin_label = get_parent_node_3d().get_node("UserInterface/Coins")
	var area3D = get_node("Area3D")
	area3D.connect('area_entered', self.on_collision)
	area3D.connect('body_entered', self.on_collision2)
	camPos = get_node("Camera3D").transform.origin
	$Player/AnimationPlayer.play("run")

	
func on_collision(body):
	if body.is_in_group("Coins"):
		print("Coin")
		coins += 20
		coin_label.text = "Rupees: " + str(coins)
	elif body.is_in_group("JumpBoost"):
		print("JumpBoost")
		jumpBoostTimer = 120
		JUMP_VELOCITY *= 2
	elif body.is_in_group("SpeedBoost"):
		print("SpeedBoost")
		speedBoostTimer = 300
		emit_signal("changeTerrainSpeed", 1)
	elif body.is_in_group("Paan"):
		print("Paan")
		paanTimer = 600
		get_node("/root/World/WorldEnvironment").environment.background_mode = 1
		get_node("/root/World/WorldEnvironment").environment.background_color = Color.MEDIUM_PURPLE
		get_node("/root/World/AudioStreamPlayer3D").pitch_scale = 3
		
	elif body.is_in_group("Obstacle"):
		get_tree().change_scene_to_file('res://Menu.tscn')
		
func on_collision2(body):
	if body.is_in_group("Obstacle"):
		get_tree().change_scene_to_file('res://Menu.tscn')

func _physics_process(delta):

	$Player/AnimationPlayer.play("run")
	
	if not is_on_floor():
		velocity.y -= gravity * delta * 1.7

	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if jumpBoostTimer > 0:
		jumpBoostTimer-=1
	if jumpBoostTimer == 0:
		JUMP_VELOCITY = 8.5
		
	if speedBoostTimer > 0:
		speedBoostTimer-=1
	if speedBoostTimer == 0:
		emit_signal("changeTerrainSpeed", 0)
		
	if paanTimer > 0:
		paanTimer -= 1
		get_node("Camera3D").transform.origin.x = 0.45 * cos(0.0075 * Time.get_ticks_msec())
		get_node("Camera3D").transform.origin.y = camPos.y + 1.45 * sin(0.0075 * Time.get_ticks_msec())
	if paanTimer == 0:
		get_node("/root/World/WorldEnvironment").environment.background_mode = 2
		get_node("/root/World/AudioStreamPlayer3D").pitch_scale = 1
		get_node("Camera3D").transform.origin = camPos
		
	self.transform.origin.x = lerp(self.transform.origin.x, (lane * 7.0) -7.0, delta * 15.0)
	self.transform.origin.x = clamp(self.transform.origin.x, -7, 7)
	
	# Check for left and right inputs
	if Input.is_action_just_pressed("left"):
		change_lane(-1) # Move left by a fixed distance.
	elif Input.is_action_just_pressed("right"):
		change_lane(1)  # Move right by a fixed distance.
	if dead != 1:
		if speedBoostTimer > 0:
			score += 4
		else:
			score += 1
		score_label.text = "Score: " + str(score)
		
	

	move_and_slide()
