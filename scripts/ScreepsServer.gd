extends Resource
class_name ScreepsServer

@export var server_name: String = "Server Name"
@export var host: String = "127.0.0.1"
@export var port: int = -1
@export var version: String = ""
@export var secure: bool = true
@export var has_likes: bool = false
@export var like_count: int = -1
@export var active: bool = false
@export var users: int = -1

func set_server_properties(name: String, host: String, port: int = -1, version: String = "", secure: bool = true, like_count: int = -1, active: bool = false):
	self.server_name = name
	self.host = host
	self.port = port
	self.version = version
	self.secure = secure
	self.like_count = like_count
	self.active = active

func to_json_string():
	return JSON.stringify({ 
		"server_name": server_name,
		"host": host,
		"port": port,
		"version": version,
		"secure": secure,
		"like_count": like_count,
		"active": active
	})
