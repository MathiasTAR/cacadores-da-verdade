extends npc

func _ready():
	anim = $Path2D/PathFollow2D/ReporterSofia/AnimatedSprite2D
	caminho = $Path2D/PathFollow2D
	dialogBox = $Path2D/PathFollow2D/ReporterSofia/Area2D/Sprite2D
	
	_dialog_data = {
		0: {
			"faceset": "",
			"facesetPlayer": "",
			"facesetNPC": "", 
			"dialog": "Estou Investigando o local!",
			"title": "Repórter Sofia Certeira"
		},
		
		1: {
			"faceset": "",
			"facesetPlayer": "",
			"facesetNPC": "", 
			"dialog": "Não me atrapalhe",
			"title": "Repórter Sofia Certeira"
		}
	}
	
	super._ready()

func _on_area_2d_area_entered(area: Area2D) -> void:
	super._on_area_entered(area)

func _on_area_2d_area_exited(area: Area2D) -> void:
	super._on_area_exited(area)
