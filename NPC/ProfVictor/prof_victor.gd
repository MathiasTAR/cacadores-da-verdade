extends npc

func _ready():
	anim = $Path2D/PathFollow2D/ProfVictor/AnimatedSprite2D
	caminho = $Path2D/PathFollow2D
	dialogBox = $Path2D/PathFollow2D/ProfVictor/Area2D/Sprite2D
	
	_dialog_data = {
		0: {
			"faceset": "",
			"facesetPlayer": "",
			"facesetNPC": "", 
			"dialog": "Estou fazendo uma analise sobre o local!",
			"title": "Prof.Victor Verídico"
		}
	}
	
	super._ready()

func _on_area_2d_area_entered(area: Area2D) -> void:
	super._on_area_entered(area)

func _on_area_2d_area_exited(area: Area2D) -> void:
	super._on_area_exited(area)
