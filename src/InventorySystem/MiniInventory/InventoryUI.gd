extends ItemList
## Inventory UI
## Created by Yni, licensed under CC0

var interact_busy: bool = false
var inv: Inventory
var using_index: int = -1
	#set(val):
		#get_parent().get_node("UseItem").disabled = (val == -1)
		#get_parent().get_node("RemoveItem").disabled = (val == -1)
		#using_index = val

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## Updates item list, by removing previous content, and ading new.
## Do NOT call this in process - it may cause lag.
func update_inventory(inventory: Inventory):
	clear()
	inv = inventory
	for inv in inventory.inventory_storage:
		if inv != null:
			add_item(inv.name, inv.texture_slot, true)


func _on_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	using_index = index
	
	# Example code from SCP: Containing Procedures
	#var pickable_path: String = inv.inventory_storage[using_index].pickable_path
	#var puppet_mesh = inv.get_parent().get_node("Puppet")
	#puppet_mesh.secondary_state = puppet_mesh.SecondaryState.ITEM
	#if puppet_mesh.get_node_or_null(puppet_mesh.armature_name + "/Skeleton3D/ItemAttachment/Marker3D") != null:
		#var puppet_hand: Marker3D = puppet_mesh.get_node(puppet_mesh.armature_name + "/Skeleton3D/ItemAttachment/Marker3D")
		#if puppet_hand.get_children().size() > 0:
			#for item in puppet_hand.get_children():
				#item.queue_free()
		#var pickable: ItemPickable = load(pickable_path).instantiate()
		#pickable.freeze = true
		#puppet_mesh.get_node(puppet_mesh.armature_name + "/Skeleton3D/ItemAttachment/Marker3D").add_child(pickable)

## Sample interact with Tileable inventory
func _on_item_activated(index: int) -> void:
	var item: InventorySlot = get_parent().add_item(inv.inventory_storage[index].id)
	var inv_panel: InventorySpace = get_parent().get_node("InventoryPanel")
	for i in range(inv_panel.max_items.x):
		for j in range(inv_panel.max_items.y):
			if get_parent().item_move(item, Vector2(get_parent().tile_size.x * i + 8, get_parent().tile_size.y * j + 8)):
				get_parent().get_node("TileInventory").remove_item(index, false)
				return
	item.queue_free()


#func _on_use_item_button_down() -> void:
	#if !interact_busy && using_index != -1:
		#interact_busy = true
		#match inv.inventory_storage[using_index].usage:
			#0:
				#Only use, not remove
				#use_or_remove(1)
			#1:
				# Use AND remove
				#use_or_remove(2)
			#2:
				# Use and drop
				#use_or_remove(3)


#func _on_remove_item_button_down() -> void:
	#if !interact_busy && using_index != -1:
		#interact_busy = true
		# Only remove, not use
		#use_or_remove(0)

#func _on_button_up() -> void:
	#interact_busy = false

# usage: 0 is "remove", 1 is "use", 2 is "use and remove", 3 is "use and drop"
# Example code from SCP: Containing Procedures
#func use_or_remove(usage: int):
	#var pickable_path: String = inv.inventory_storage[using_index].pickable_path
	#var pickable: ItemPickable
	#if usage == 3: # Drop item and use them
		#pickable = load(pickable_path).instantiate()
		#pickable.freeze = false
		#pickable.position = inv.get_parent().global_position
		#get_tree().root.get_node("Game/Items").add_child(pickable)
		#pickable.call("use", inv.get_parent(), inv.get_parent())
	#var puppet_mesh = inv.get_parent().get_node("Puppet")
	#if puppet_mesh.get_node_or_null(puppet_mesh.armature_name + "/Skeleton3D/ItemAttachment/Marker3D") != null:
		#var puppet_hand: Marker3D = puppet_mesh.get_node(puppet_mesh.armature_name + "/Skeleton3D/ItemAttachment/Marker3D")
		#if puppet_hand.get_children().size() > 0:
			#if usage == 1 || usage == 2: # Use item, while holding in hand
				#pickable = puppet_hand.get_child(0)
				#pickable.call("use", inv.get_parent(), inv.get_parent())
			#if usage != 1:
				#for item in puppet_hand.get_children():
					#item.queue_free()
	#if usage == 0 || usage == 2 || usage == 3: #Remove the item from the inventory
		#if usage == 0:
			#inv.remove_item(using_index, true)
		#else:
			#inv.remove_item(using_index, false)
		#update_inventory(inv)


func _on_inventory_update_inventory() -> void:
	update_inventory(get_parent().get_node("TileInventory"))
