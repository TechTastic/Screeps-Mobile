extends Node


signal community_servers_updated(server_list: Array[ScreepsServer])


@export var official_server_list: Array[ScreepsServer] = [
	ScreepsWorldServer.new(),
	ScreepsSeasonalServer.new()
]
@export var community_server_list: Array[ScreepsServer] = []
@export var private_server_list: Array[ScreepsServer] = []


func _ready():
	community_servers_updated.connect(func(server_list: Array[ScreepsServer]): community_server_list = server_list)
	await ScreepsHTTP.get_community_server_list(community_servers_updated)


func save_server_list(path: String, servers: Array[ScreepsServer]):
	var file: FileAccess = FileAccess.open(path, FileAccess.WRITE)
	file.store_var(servers)


func load_server_list(path: String):
	pass
