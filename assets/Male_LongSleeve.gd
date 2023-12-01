

var lane = 1


func change_lane(change):
	lane += change;
	if lane > 2:
		lane = 2
	if lane < 0:
		lane = 0
	
func _ready():
	pass

func _physics_process(delta):
		
	self.transform.origin.x = lerp(self.transform.origin.x, (lane * 7.0) -7.0, delta * 15.0)
	self.transform.origin.x = clamp(self.transform.origin.x, -7, 7)
	
	# Check for left and right inputs
	if Input.is_action_just_pressed("left"):
		change_lane(-1) # Move left by a fixed distance.
	elif Input.is_action_just_pressed("right"):
		change_lane(1)  # Move right by a fixed distance.

