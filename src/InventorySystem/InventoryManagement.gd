extends Control
class_name InventoryPanel

signal item_added(item_id: int)
signal item_removed(item_id: int)
@onready var inventory_panel = $InventoryPanel
@export var tile_size: Vector2 = Vector2(32, 32)
@export var dimensions: Vector2i = Vector2i(4, 4)
@export var item_res_path: ItemRes #change later to your own type for your game, this is an example
@export var max_items_outside_inventory = 1
var item_counter: int = 0
var items_array: Array[TextureRect] = []
var is_item_selected: bool = false
var selected_item: TextureRect
var is_dragging: bool = false
var item_prev_position: Vector2 = Vector2.ZERO
var selected_item_z_index: int = 1000

func add_item(item_id: int):
	if item_counter >= max_items_outside_inventory:
		return
	else:
		item_counter += 1
	var item: Item = item_res_path.items[item_id]
	var item_prefab: InventorySlot = InventorySlot.new()
	item_prefab.global_position = $DockPanel.global_position
	item_prefab.item_id = item.id
	item_prefab.texture = item.texture
	item_prefab.connect("gui_input", Callable(self, "on_gui_input").bind(item_prefab))
	add_child(item_prefab, true)

func on_gui_input(event: InputEvent, prefab: TextureRect):
	if event.is_action_pressed("inventory_item_selected"):
		is_item_selected = true
		selected_item = prefab
		selected_item.z_index = selected_item_z_index
		item_prev_position = prefab.position
	
	if event is InputEventMouseMotion:
		if is_item_selected:
			is_dragging = true
	# touch screen
	elif event is InputEventScreenDrag:
		if is_item_selected:
			is_dragging = true
	
	if event.is_action_released("inventory_item_selected"):
		selected_item.z_index = 0
		
		is_item_selected = false
		is_dragging = false
		selected_item = null
	
	if event.is_action_released("inventory_remove_item"):
		remove_item(prefab.get_path())
## Moves item in the inventory
func item_move(item: InventorySlot, pos: Vector2):
	if item.first_start:
		item_counter -= 1
		items_array.append(item)
		item_added.emit(item.item_id)
		item.first_start = false
	item.position = ($InventoryPanel.global_position + pos).snapped(tile_size)
	if !$InventoryPanel.get_rect().intersects(item.get_rect()):
		item.position = item_prev_position
	for item_check in items_array:
		if item_check.name != item.name:
			if item_check.get_rect().intersects(item.get_rect()):
				item.position = item_prev_position
	item_prev_position = Vector2.ZERO
## Removes item and calls signal (e.g. for dropping item on the ground)
func remove_item(prefab_path: String):
	var prefab = get_node(prefab_path)
	prefab.disconnect("gui_input", Callable(self, "on_gui_input").bind(prefab))
	item_removed.emit(prefab.item_id)
	items_array.erase(prefab)
	prefab.queue_free()
