class_name ThumbnailRenderer
extends Node

signal completed

var thread: Thread = Thread.new()

func make_thumbnail(video_filepath):
	var thumbnail_path = "user://cache/" + (video_filepath.replace(".mp4", ".png"))
	var arguments = [
				"-i", video_filepath,
				"-vf", "select=eq(n\\,0)",
				"-q:v", "3",
				ProjectSettings.globalize_path(thumbnail_path)
			]
	var output = []
	
	OS.execute("ffmpeg", arguments, output, true)
	print(output)
	call_deferred(&"complete")

func complete():
	thread.wait_to_finish()
	completed.emit()
