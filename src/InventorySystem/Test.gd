extends Button


@export var item_index: int = 0

func _on_pressed():
	get_parent().get_node("TileInventory").add_item(get_parent().item_res_path.items[item_index])
