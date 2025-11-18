extends ItemInteragivelBase

func _ready():
	interaction_icon = $Area2D/Sprite2D
	
	_dialog_data = {
		0: {
			"faceset": "",
			"facesetPlayer": "",
			"facesetNPC": "", 
			"dialog": "Pegar Papel?",
			"title": ""
		},
	}
	
	super._ready()

func _execute_item_behavior():
	super._execute_item_behavior()
	
	print("Pegou Papel!")

func _on_area_2d_area_entered(area: Area2D):
	super._on_area_entered(area)

func _on_area_2d_area_exited(area: Area2D):
	super._on_area_exited(area)
