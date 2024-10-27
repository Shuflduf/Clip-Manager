class_name Clip
extends PanelContainer

@onready var texture: TextureRect = $VBoxContainer/Corners/TextureRect
@onready var label: Label = $VBoxContainer/Label

@export_color_no_alpha var selected_color = Color("cccccc")

var file_path: String

func select():
	var panel = get_theme_stylebox(&"panel").duplicate()
	panel.border_color = selected_color
	add_theme_stylebox_override(&"panel", panel)

func deselect():
	var panel = get_theme_stylebox(&"panel").duplicate()
	panel.border_color = panel.bg_color
	add_theme_stylebox_override(&"panel", panel)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_LEFT:
				get_parent().clip_selected.emit(self)
				select()
				if event.double_click:
					get_parent().clip_opened.emit(self)
			if event.button_index == MOUSE_BUTTON_RIGHT:
				$RightClick.show()
				$RightClick.position = \
					event.position + Vector2(10, 10) + position


func _on_right_click_index_pressed(index: int) -> void:
	match index:
		0:
			get_parent().clip_opened.emit(self)
		1:
			get_parent().clip_opened_in_explorer.emit(self)
		2:
			$RightClick/PopupPanel.show()
		


func _on_popup_panel_close_requested() -> void:
	$RightClick/PopupPanel.hide()


func _on_delete_pressed() -> void:
	get_parent().clip_deleted.emit(self)


func _on_keep_pressed() -> void:
	_on_popup_panel_close_requested()
