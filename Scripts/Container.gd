extends Node2D

var dimension_resources = preload("res://Resource/Dimension Resources.tres")

export(String, FILE, "*.tscn") var world_file

const PRIMARY_MODULATE = Color("a9a2ff");
const SECONDARY_MODULATE = Color("ff849d");

var sensitivity = 1

func _ready():
	#defer loading, tree is locked during _ready
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	call_deferred("load_world_file", world_file)
	
func move_portal(portal_pos : Vector2):
	var collision_map = dimension_resources.collision_map
	var overworld_map = dimension_resources.overworld_map
	var subworld_map = dimension_resources.subworld_map
	
	if collision_map == null or overworld_map == null or subworld_map == null:
		return
	
	var portal = dimension_resources.portal
	
	collision_map.clear()
	
	var used_rect = overworld_map.get_used_rect()
	for i in range(used_rect.position.x, used_rect.end.x):
		for j in range(used_rect.position.y, used_rect.end.y):
			collision_map.set_cell(i, j, overworld_map.get_cell(i, j))
	
	var count = 0
	for i in range(portal_pos.x - portal.COLLISION_RADIUS, portal_pos.x + portal.COLLISION_RADIUS, 4):
		for j in range(portal_pos.y - portal.COLLISION_RADIUS, portal_pos.y + portal.COLLISION_RADIUS, 4):
			if sq(i - portal_pos.x) + sq(j - portal_pos.y) <= sq(portal.COLLISION_RADIUS):
				count += 1
				var tile_coords = collision_map.world_to_map(Vector2(i,j))
				collision_map.set_cellv(tile_coords, subworld_map.get_cellv(tile_coords))
	
func _input(event):
	if event is InputEventMouseMotion:
		var portal = dimension_resources.portal
		if portal:
			var new_pos = portal.portal_position + event.relative * sensitivity
			var camera_pos = $MainCamera.get_camera_pos()
			new_pos.x = clamp(new_pos.x, camera_pos.x, camera_pos.x + 192)
			new_pos.y = clamp(new_pos.y, camera_pos.y, camera_pos.y + 108)
			
			portal.portal_position = new_pos
			call_deferred("move_portal", portal.portal_position)
	if Input.is_action_just_pressed("exit"):
		pause()

func pause():
	get_tree().paused = true;
	$PauseCanvas/PauseMenu.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func resume():
	get_tree().paused = false;
	$PauseCanvas/PauseMenu.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func sq(v):
	return v * v

func load_world_file(file : String):
	var Scene = load(file) as PackedScene
	var scene = Scene.instance()
	var overworld = scene.find_node("Overworld")
	var subworld = scene.find_node("Subworld")
	var objects = scene.find_node("Objects")
	
	scene.remove_child(overworld)
	scene.remove_child(subworld)
	scene.remove_child(objects)
	scene.queue_free() #!!! needs to be freed explicity to avoid leak?
	
	overworld.modulate = PRIMARY_MODULATE
	subworld.modulate = SECONDARY_MODULATE
	
	dimension_resources.overworld_tree = overworld
	dimension_resources.subworld_tree = subworld
	dimension_resources.object_tree = objects
	
	$WorldViewport.add_child(overworld)
	$SubworldViewport.add_child(subworld)
	$Objects.add_child(objects)
	
	move_portal(Vector2(0,0))
