extends Resource
class_name ScreepsServer

const http_url_format := "{0}://{1}{2}/{3}"

signal server_info_updated(server: ScreepsServer)

# Data from /api/servers/list
var _id: String = ""
@export var host: String = ""
@export var port: String = ""
@export var password: String = ""
@export var server_name: String = ""
var status: String = ""
var like_count: int = -1

@export var secure: bool = true

# Data from /api/version
var protocal: int = 14
var custom_object_types: Dictionary = {}
var mods: Array = []
var history_chunk_size: int = 0
var renderer: Dictionary = {}
var shards: PackedStringArray = PackedStringArray()
var socket_update_throttle: int = 0
var welcome_text: String = ""
var use_native_auth: bool = true
var users: int = 0

func to_json_string() -> String:
	return JSON.stringify({
		"_id": self._id,
		"protocol": self.protocal,
		"host": self.host,
		"port": self.port,
		"pass": self.password,
		"name": self.server_name,
		"status": self.status,
		"likeCount": self.like_count,
		"serverData": {
			"customObjectTypes": self.custom_object_types,
			"mods": self.mods,
			"historyChunkSize": self.history_chunk_size,
			"renderer": self.renderer,
			"shards": self.shards,
			"socketUpdateThrottle": self.socket_update_throttle,
			"welcomeText": self.welcome_text
		},
		"useNativeAuth": self.use_native_auth,
		"users": self.users
	})

func read_from_server_list(json: Dictionary) -> ScreepsServer:
	self._id = json._id
	self.host = json.settings.host
	self.port = json.settings.port
	self.password = json.settings.pass
	self.server_name = json.name
	self.status = json.status
	self.like_count = json.likeCount
	self.secure = false
	
	return self

func read_from_server_data(json: Dictionary) -> ScreepsServer:
	var server_data: Dictionary = json.serverData
	
	self.protocal = json.protocol
	self.custom_object_types = server_data.customObjectTypes
	self.mods = server_data.features
	self.history_chunk_size = server_data.historyChunkSize
	self.renderer = server_data.renderer
	var is_null = server_data.shards.count(null) > 0
	if !is_null: self.shards = server_data.shards
	self.socket_update_throttle = server_data.get("socketUpdateThrottle", -1)
	self.welcome_text = server_data.get("welcomeText", "")
	self.use_native_auth = json.get("usesNativeAuth", true)
	self.users = json.users
	
	return self

func get_http_url(endpoint: String) -> String:
	return http_url_format.format([
		(func(): if (self.secure): return "https" else: return "http").call(),
		self.host,
		(func(): if (self.port != ""): return ":" + self.port else: return "").call(),
		endpoint
	])

func request_server_info():
	ScreepsHTTP.get_server_info(self)
