extends npc

func _ready():
	anim = $Path2D/PathFollow2D/DraClara/AnimatedSprite2D
	caminho = $Path2D/PathFollow2D
	dialogBox = $Path2D/PathFollow2D/DraClara/Area2D/Sprite2D
	
	_dialog_data = {
		0: {
			"faceset": "",
			"facesetPlayer": "",
			"facesetNPC": "", 
			"dialog": "''Não há fatos eternos, como não há verdades absolutas.''\n\nFriedrich Nietzsche",
			"title": "Dra.Clara Contexto"
		}
	}
	
	super._ready()

func _on_area_2d_area_entered(area: Area2D) -> void:
	super._on_area_entered(area)

func _on_area_2d_area_exited(area: Area2D) -> void:
	super._on_area_exited(area)
