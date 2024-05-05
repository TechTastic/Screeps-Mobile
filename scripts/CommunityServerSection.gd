extends ServerSection
class_name CommunityServerSection

signal list_updated(new_list: Array)

func _ready():
	load_server_list()
	list_updated.connect(_on_list_updated)
	super()

func load_server_list():
	await ScreepsHTTP.get_community_server_list(list_updated)

func _on_list_updated(new_list: Array):
	self.server_list.clear()
	for i in $VBoxContainer/ServerScroll/ServerList.get_children().size():
		var child = $VBoxContainer/ServerScroll/ServerList.get_children()[i]
		if child is ServerButton:
			child.queue_free()
	self.server_list.append_array(new_list)
	self.generate_server_list_buttons()
