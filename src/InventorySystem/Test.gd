extends Button


@export var item_index: int = 0

func _on_pressed():
	get_parent().get_node("Inventory").add_item(item_index)
