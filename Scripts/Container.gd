extends Node2D

var dimension_resources = preload("res://Resource/Dimension Resources.tres")
var Player = preload("res://Scenes/Player.tscn")

export(String, FILE, "*.tscn") var world_file

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
		print("maps not found!")
		return
	
	var portal = dimension_resources.portal
	
	collision_map.clear()
	
	var used_rect = overworld_map.get_used_rect()
	for i in range(used_rect.position.x, used_rect.end.x):
		for j in range(used_rect.position.y, used_rect.end.y):
			collision_map.set_cell(i, j, overworld_map.get_cell(i, j))
	
	for i in range(portal_pos.x - portal.radius, portal_pos.x + portal.radius, 4):
		for j in range(portal_pos.y - portal.radius, portal_pos.y + portal.radius, 4):
			if sq(i - portal_pos.x) + sq(j - portal_pos.y) <= sq(portal.radius):
				var tile_coords = collision_map.world_to_map(Vector2(i,j))
				collision_map.set_cellv(tile_coords, subworld_map.get_cellv(tile_coords))
				
func sq(v):
	return v * v

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
	elif event is InputEventMouseButton:
		var portal = dimension_resources.portal
		if portal:
			print("transitioning...")
			portal.transition_radius(25 if event.pressed else 0)
	if Input.is_action_just_pressed("exit"):
		pause()

func pause():
	get_tree().paused = true;
	$GUICanvas/PauseMenu.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func resume():
	get_tree().paused = false;
	$GUICanvas/PauseMenu.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func player_died(_area):
	var fade = $GUICanvas/DeathFade
	fade.fade()
	yield(fade, "finished")
	var player = dimension_resources.player
	player.respawn()
	fade.unfade()

func _on_Fragment_collected():
	print("coin noises")

func prepare_objects():
	print("Preparing objects")
	move_portal(Vector2(0,0))
	
	var player = Player.instance()
	$Objects.add_child(player)
	
	var barrel_path = dimension_resources.get_barrel()
	
	var barrel = get_tree().get_root().get_node(barrel_path)
	
	if player != null:
		player.connect("death_area_entered", self, "player_died")
		if barrel != null:
			player.global_position = barrel.get_spawn_position()
		else:
			print("No barrel found!")
		$MainCamera.set_position_rounded(player.global_position)
	
	for fragment in get_tree().get_nodes_in_group("fragments"):
		fragment.connect("collected", self, "_on_Fragment_collected")

func destroy_children(node : Node):
	for child in node.get_children():
		if not child is Camera2D:
			node.remove_child(child)
			child.queue_free()

func load_world_file(file : String):
	print("Loading file %s" % file)
	destroy_children($WorldViewport)
	destroy_children($SubworldViewport)
	destroy_children($PortalMaskViewport)
	destroy_children($Objects)
	print("Destroyed nodes")
	
	var Scene = load(file) as PackedScene
	var scene = Scene.instance()
	var overworld = scene.find_node("Overworld")
	var subworld = scene.find_node("Subworld")
	var objects = scene.find_node("Objects")
	var portal_objects = scene.find_node("PortalObjects")
	
	print("Extracting nodes")
	scene.remove_child(overworld)
	scene.remove_child(subworld)
	scene.remove_child(objects)
	scene.remove_child(portal_objects)
	scene.queue_free() #!!! needs to be freed explicity to avoid leak?
	
	$WorldViewport.add_child(overworld)
	$SubworldViewport.add_child(subworld)
	$Objects.add_child(objects)
	$PortalMaskViewport.add_child(portal_objects)
	prepare_objects()
