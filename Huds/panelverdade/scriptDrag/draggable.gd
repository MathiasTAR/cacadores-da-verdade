extends TextureRect

@export_enum("Npc", "Item") var PanelVerdade = 0

func _get_drag_data(at_position: Vector2) -> Variant:
	var data = [self, PanelVerdade]
	visible = false
	var preview = TextureRect.new()
	preview.texture = texture
	set_drag_preview(preview)
	return data
	
func _notification(notification_type) -> void:
	match notification_type:
		NOTIFICATION_DRAG_END:
			visible = true
