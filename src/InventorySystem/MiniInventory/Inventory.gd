extends Node
## Simple inventory
## Created by Yni, licensed under CC0
class_name Inventory

signal update_inventory
## Where the items are contained
@export var inventory_storage: Array[Item] = []
## Inventory size
@export var size: int:
	set(val):
		size = val
		inventory_storage.clear()
		if val > 1:
			for i in range(size):
				inventory_storage.append(null)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	size = get_parent().max_items_outside_inventory


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## Adds item as last
func add_item(item: Item) -> bool:
	for i in range(size):
		if inventory_storage[i] != null:
			continue
		else:
			inventory_storage[i] = item
			update_inventory.emit()
			return true
	printerr("The max item limit is reached")
	return false
## Sets item by id
func set_item(id: int, item: Item) -> bool:
	if id > size || id < 0:
		printerr("Value not valid")
		return false
	inventory_storage[id] = item
	update_inventory.emit()
	return true
## Finds and removes item.
func remove_item(id: int, drop: bool) -> void:
	#if drop:
		#get_tree().root.get_node("Game/Items").object_spawner(inventory_storage[id], get_parent().global_position)
	inventory_storage.pop_at(id)
	inventory_storage.append(null)
	update_inventory.emit()
## Finds item by name
func find_item(item_name: String) -> Item:
	for inv in inventory_storage:
		if inv.name == item_name:
			return inv
	return null
