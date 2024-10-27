extends Control

@export var tag_scene: PackedScene
@export var clip_scene: PackedScene
@export_global_dir var target_folder: String

var active_clip: Clip

func _ready() -> void:
	if !DirAccess.dir_exists_absolute("user://cache/"):
		DirAccess.make_dir_absolute("user://cache/")
	
	for temp in DirAccess.get_files_at("user://cache/"):
		DirAccess.remove_absolute("user://cache/" + temp)
	
	for file in DirAccess.get_files_at(target_folder):
		if !file.ends_with(".mp4"):
			continue
		
		var thumbnail_path = "user://cache/" + file.replace(".mp4", ".png")
		var arguments = [
					"-i", target_folder + "/" + file,
					"-vf", "select=eq(n\\,0)",
					"-q:v", "3",
					ProjectSettings.globalize_path(thumbnail_path)
				]

		OS.execute("ffmpeg", arguments)
		
		var new_clip = clip_scene.instantiate()
		%Clips.add_child(new_clip)
		
		var image = Image.new()
		var err = image.load(thumbnail_path)
		if err != OK:
			print(err)
		var texture = ImageTexture.create_from_image(image)
		new_clip.texture.texture = texture
		
		new_clip.file_path = file
		
		var unix = FileAccess.get_modified_time(target_folder + "/" + file)
		var time = Time.get_datetime_dict_from_unix_time(unix)
		var time_string = \
				Months.MONTHS[time["month"]] + " " + \
				str(time["day"]) + ", " + \
				str(time["year"])
		new_clip.label.text = time_string
		

func _on_new_tag_pressed() -> void:
	if active_clip == null:
		return
	var new_tag = tag_scene.instantiate()
	%Tags.add_child(new_tag)
	new_tag.line_edit.grab_focus()


func _on_tags_new_tag_requested() -> void:
	DirAccess.rename_absolute(
		target_folder + "/" + active_clip.file_path,
		target_folder + "/" + make_filename()
	)
	active_clip.file_path = make_filename()
	_on_new_tag_pressed()

func _on_clips_clip_selected(clip: Clip) -> void:
	active_clip = clip
	for i in %Clips.get_children():
		i.deselect()
	
	for i in %Tags.get_children():
		i.queue_free()
		
	for i in clip.file_path.trim_suffix(".mp4").split("-"):
		var new_tag = tag_scene.instantiate()
		%Tags.add_child(new_tag)
		new_tag.tag = i
		
		if i == i.to_upper():
			new_tag.highlight()

func make_filename() -> String:
	var filename = ""
	for tag in %Tags.get_children():
		filename += tag.tag 
		filename += "-"
	filename = filename.trim_suffix("-")
	filename += ".mp4"
	print(filename)
	return filename


func _on_clips_clip_opened(clip: Clip) -> void:
	OS.shell_open(target_folder + "/" + clip.file_path)


func _on_refresh_pressed() -> void:
	active_clip = null
	for i in %Clips.get_children():
		i.queue_free()
	for i in %Tags.get_children():
		i.queue_free()
	
	_ready()


func _on_clips_clip_opened_in_explorer(clip: Clip) -> void:
	OS.shell_show_in_file_manager(target_folder + "/" + clip.file_path)


func _on_clips_clip_deleted(clip: Clip) -> void:
	if clip ==  active_clip:
		for i in %Tags.get_children():
			i.queue_free()
		active_clip = null
	
	clip.queue_free()
	DirAccess.remove_absolute(target_folder + "/" + clip.file_path)
