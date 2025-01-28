extends Panel
## Tile inventory system
## Made by Yni, licensed under CC0
class_name Inventory

var game_data: ItemRes
@export var tile_size: int = 96
@export var max_tiles: Vector2i = Vector2i(4, 4)

var _items: Array[InventorySlot]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_data = load("res://InventorySystem/Items/Items.tres")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_item(item_id: int):
	var item_prefab: InventorySlot = InventorySlot.new()
	item_prefab.item_id = item_id
	item_prefab.texture = game_data.items[item_id].texture_tiled
	add_child(item_prefab)
	item_prefab.position = Vector2(-16, -16)
	_items.append(item_prefab)
	# Auto-align item in inventory
	for i in range(max_tiles.x):
		for j in range(max_tiles.y):
			if item_move(item_prefab, Vector2(tile_size * i + 8, tile_size * j + 8)):
				return
	# If there is no place - no item will be picked
	item_remove(item_prefab, true)

func item_move(prefab: InventorySlot, pos: Vector2) -> bool:
	pos = pos.snappedf(tile_size)
	var prev_pos = prefab.position
	prefab.position = pos
	if prefab.get_global_rect().intersection(get_global_rect()) != prefab.get_global_rect():
		prefab.position = prev_pos
		return false
	for item in _items:
		if prefab.get_global_rect().intersects(item.get_global_rect()) && item != prefab:
			prefab.position = prev_pos
			return false
	return true

func item_remove(item: InventorySlot, drop: bool) -> bool:
	for i in _items:
		if i == item:
			if drop:
				# Create drop item mechanic
				pass
			_items.erase(i)
			i.queue_free()
			return true
	print("No item for delete found")
	return false

func use_item(item: InventorySlot):
	if game_data.items[item.item_id].usage != 0:
		item_remove(item, game_data.items[item.item_id].usage == 2)
	# write usage mechanic

## the item could be dropped only inside inventory
func _can_drop_data(at_position, data):
	return true

func _drop_data(at_position, data):
	item_move(data, at_position)
