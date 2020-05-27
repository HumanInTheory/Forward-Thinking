extends RichTextLabel

func _on_Credits_meta_clicked(meta):
	if not meta is String:
		return
	var json = parse_json(meta)
	if json is Dictionary:
		if json.has("url"):
			OS.shell_open(json["url"])
