extends ItemColetavelBase

func _ready():
	interaction_icon = $Area2D/Sprite2D
	
	_dialog_data = {
		0: {
			"faceset": "",
			"facesetPlayer": "",
			"facesetNPC": "", 
			"dialog": "Você encontrou uma Bolinha de Papel!",
			"title": ""
		},
		1: {
			"faceset": "",
			"facesetPlayer": "", 
			"facesetNPC": "",
			"dialog": "Agora você pode jogar nos amiguinhos!",
			"title": ""
		}
	}
	
	super._ready()

func _on_area_2d_area_entered(area: Area2D):
	super._on_area_entered(area)

func _on_area_2d_area_exited(area: Area2D):
	super._on_area_exited(area)
