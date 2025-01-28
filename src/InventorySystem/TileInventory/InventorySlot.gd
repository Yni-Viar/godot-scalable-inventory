extends TextureRect
## Inventory slot
## Made by Yni, licensed under CC0.
class_name InventorySlot

## Item ID
@export var item_id: int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.double_click && event.is_action_pressed("item_use"):
			get_parent().use_item(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

## Set texture preview
func _get_drag_data(at_position):
	var preview: TextureRect = TextureRect.new()
	preview.texture = texture
	set_drag_preview(preview)
	return self
