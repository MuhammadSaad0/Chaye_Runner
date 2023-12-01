extends Node3D
class_name TerrainController
## This builds and operates the terrain "conveyor belt"
##
## A set of randomly choosen terrain blocks is rendered to the viewport.
## As the game is played the terrian is moved in the posative Z direction.
## When a given block passes behind this node it is removed and a new block
## is added to the far end of the conveyor

## Holds the catalog of loaded terrian block scenes
var TerrainBlocks: Array = [preload("res://terrain_blocks/terrain_1.tscn"), preload("res://terrain_blocks/terrain_2.tscn"), preload("res://terrain_blocks/terrain_3.tscn"), preload("res://terrain_blocks/terrain_4.tscn"), preload("res://terrain_blocks/terrain_5.tscn"), preload("res://terrain_blocks/terrain_6.tscn"), preload("res://terrain_blocks/terrain_7.tscn")]
var Pickups: Array = []
## The set of terrian blocks which are currently rendered to viewport
var terrain_belt: Array[MeshInstance3D] = []
@export var terrain_velocity: float = 10.0
var old_terrain_velocity: float = 10.0
## The number of blocks to keep rendered to the viewport
@export var num_terrain_blocks = 10
## Path to directory holding the terrain block scenes
@export_dir var terrian_blocks_path = "res://terrain_blocks"
@export_dir var pickups_path = "res://pickups"

func _ready() -> void:
	_load_pickups(pickups_path)
	_init_blocks(num_terrain_blocks)
	get_parent_node_3d().get_node("Player").connect('changeTerrainSpeed', self.changeTerrainSpeed)

func _physics_process(delta: float) -> void:
	_progress_terrain(delta)

func changeTerrainSpeed(val):
	if val == 1:
		old_terrain_velocity = terrain_velocity
		terrain_velocity *= 1.5
		if terrain_velocity > terrain_velocity * 2:
			terrain_velocity = terrain_velocity * 2
	else:
		terrain_velocity = old_terrain_velocity

func _init_blocks(number_of_blocks: int) -> void:
		
		var block
		block = TerrainBlocks[0].instantiate()
		block.position.z = block.mesh.size.y/2
		add_child(block)
		terrain_belt.append(block)
		block = TerrainBlocks[0].instantiate()
		_append_to_far_edge(terrain_belt[0], block)
		add_child(block)
		terrain_belt.append(block)
		for i in range(number_of_blocks):
			block = TerrainBlocks.pick_random().instantiate()
			_append_to_far_edge(terrain_belt[i+1], block)
			add_child(block)
			terrain_belt.append(block)


func _progress_terrain(delta: float) -> void:
	
	for block in terrain_belt:
		block.position.z += terrain_velocity * delta

	if terrain_belt[0].position.z >= terrain_belt[0].mesh.size.y/0.5:
		var last_terrain = terrain_belt[-1]
		var first_terrain = terrain_belt.pop_front()

		var block = TerrainBlocks.pick_random().instantiate()
		var posrand = randi()%3
		var pickupSpawn = randi_range(0, 1)
		if pickupSpawn == 1:
			if posrand == 0:
				posrand = -7
			elif posrand == 1:
				posrand = 0
			elif posrand == 2:
				posrand = 7
			var pickup = Pickups.pick_random().instantiate()
			pickup.transform.origin.x = posrand
			block.add_child(pickup)
		
		_append_to_far_edge(last_terrain, block)
		add_child(block)

		terrain_belt.append(block)
		first_terrain.queue_free()


func _append_to_far_edge(target_block: MeshInstance3D, appending_block: MeshInstance3D) -> void:
	appending_block.position.z = target_block.position.z - target_block.mesh.size.y/2 - appending_block.mesh.size.y/2


func _load_terrain_scenes(target_path: String) -> void:
	var dir = DirAccess.open(target_path)
	for scene_path in dir.get_files():
		print("Loading terrian block scene: " + target_path + "/" + scene_path)
		TerrainBlocks.append(load(target_path + "/" + scene_path))
		
func _load_pickups(target_path: String) -> void:
	var dir = DirAccess.open(target_path)
	for scene_path in dir.get_files():
		print("Loading pickups: " + target_path + "/" + scene_path)
		Pickups.append(load(target_path + "/" + scene_path))
