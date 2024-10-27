extends PanelContainer

@onready var line_edit: LineEdit = $LineEdit
@export_color_no_alpha var highlighted_color: Color

@export var tag: String:
	set(value):
		line_edit.text = value
		tag = value

func highlight():
	var panel = get_theme_stylebox(&"panel").duplicate()
	panel.bg_color = highlighted_color
	add_theme_stylebox_override(&"panel", panel)

func _on_line_edit_text_submitted(new_text: String) -> void:
	if new_text.is_empty():
		queue_free()
		return
	
	if new_text == new_text.to_upper():
		highlight()
	
	line_edit.release_focus()
	tag = new_text
	get_parent().new_tag_requested.emit()
	
