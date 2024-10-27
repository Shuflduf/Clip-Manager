extends Control

@export var tag_scene: PackedScene

func _on_new_tag_pressed() -> void:
	var new_tag = tag_scene.instantiate()
	%Tags.add_child(new_tag)
	new_tag.line_edit.grab_focus()


func _on_tags_new_tag_requested() -> void:
	_on_new_tag_pressed()
