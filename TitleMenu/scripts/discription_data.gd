extends Resource
class_name DiscriptionData

@export var name:String
@export var screanshot:Texture2D:
	set(value):
			screanshot = value
			emit_changed()
@export var Scean:PackedScene
@export_multiline var how_to_oparate:String
@export_multiline var gema_explanation:String
