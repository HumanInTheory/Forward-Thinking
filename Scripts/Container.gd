extends Node2D

var dimension_resources = preload("res://Resource/Dimension Resources.tres")
var Player = preload("res://Scenes/Player.tscn")

export(String, FILE, "*.tscn") var world_file

var sensitivity = 1

func _ready():
	#defer loading, tree is locked during _ready
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	call_deferred("load_world_file", world_file)
	
func _on_Portal_portal_changed():
	var portal = dimension_resources.portal
	if portal != null and portal.radius > 0:
		call_deferred("do_portal_tiles", portal.radius, portal.portal_position)

func do_portal_tiles(radius, position):
	var collision_map = dimension_resources.collision_map
	var overworld_map = dimension_resources.overworld_map
	var subworld_map = dimension_resources.subworld_map
	
	if collision_map == null or overworld_map == null or subworld_map == null:
		print("maps not found!")
		return
	
	collision_map.clear()
	
	var used_rect = overworld_map.get_used_rect()
	for i in range(used_rect.position.x, used_rect.end.x):
		for j in range(used_rect.position.y, used_rect.end.y):
			collision_map.set_cell(i, j, overworld_map.get_cell(i, j))
	
	if radius < 4:
		return
	
	for i in range(position.x - radius, position.x + radius, 4):
		for j in range(position.y - radius, position.y + radius, 4):
			if sq(i - position.x) + sq(j - position.y) <= sq(radius):
				var tile_coords = collision_map.world_to_map(Vector2(i,j))
				collision_map.set_cellv(tile_coords, subworld_map.get_cellv(tile_coords))
	
	collision_map.update_dirty_quadrants()

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
	elif event is InputEventMouseButton:
		var portal = dimension_resources.portal
		if portal:
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
	$MainCamera.set_locked(true)
	var fade = $GUICanvas/DeathFade
	fade.fade()
	
	yield(fade, "finished")
	
	var player = dimension_resources.player
	var barrel_path = dimension_resources.get_barrel()
	var barrel = get_tree().get_root().get_node(barrel_path)
	
	if barrel:
		player.respawn(barrel.get_spawn_position())
		$MainCamera.set_position_rounded(barrel.get_spawn_position())
	$MainCamera.set_locked(false)
	fade.unfade()

func _on_Fragment_collected():
	print("coin noises")

func prepare_objects():
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
	
	var portal = dimension_resources.portal
	if portal != null:
		portal.connect("portal_changed", self, "_on_Portal_portal_changed")
		call_deferred("do_portal_tiles", portal.radius, portal.portal_position)
	
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
