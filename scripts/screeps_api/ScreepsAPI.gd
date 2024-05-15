extends Node

@export var official_server_list: Array = [
	ScreepsWorldServer.new(),
	ScreepsSeasonalServer.new()
]
@export var community_server_list: Array = []
@export var private_server_list: Array = []

func save_server_list(path: String, servers: Array):
	var file: FileAccess = FileAccess.open(path, FileAccess.WRITE)
	file.store_var(servers)

func load_server_list(path: String):
	pass
