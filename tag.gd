extends PanelContainer

@onready var line_edit: LineEdit = $LineEdit

@export var tag: String:
	set(value):
		line_edit.text = value
		tag = value


func _on_line_edit_text_submitted(new_text: String) -> void:
	if new_text.is_empty():
		queue_free()
		return
	
	#get_parent
	line_edit.release_focus()
	tag = new_text
	get_parent().new_tag_requested.emit()
	
