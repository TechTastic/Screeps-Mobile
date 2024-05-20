extends Node

var ahttp: AwaitableHTTPRequest = AwaitableHTTPRequest.new()


func _ready():
	add_child(ahttp)
	ahttp.timeout = 2.5


func get_community_server_list(callback: Signal):
	var url = "https://screeps.com/api/servers/list"
	
	await wait_before_requesting()
	
	var r := await ahttp.async_request(url, HTTPClient.METHOD_POST)
	
	if r.success:
		var json = r.json
		if json != null and !json.has("error") and json.has("servers"):
			var server_list: Array[ScreepsServer] = []
			for json_server in json.servers:
				var server := ScreepsServer.new()
				server.read_from_server_list(json_server)
				server_list.push_back(server)
			callback.emit(server_list)
		else:
			print("Failed to get servers for Community Server List!")
			print(r.headers)
			print(r.body)


func get_server_info(server: ScreepsServer):
	var url: String = server.get_http_url("api/version")
	
	await wait_before_requesting()
	var r := await ahttp.async_request(url)
	
	if r.success and str(r.status_code).match("2??"):
		print(r.json)
		var new_server: ScreepsServer = server.read_from_server_data(r.json)
		new_server.status = "active"
		server.server_info_updated.emit(new_server)
	elif r._result == HTTPRequest.RESULT_TLS_HANDSHAKE_ERROR:
		await wait_before_requesting()
		r = await ahttp.async_request(url.replace("https", "http"))
		
		if r.success and str(r.status_code).match("2??"):
			print(r.json)
			var new_server: ScreepsServer = server.read_from_server_data(r.json)
			new_server.secure = false
			new_server.status = "active"
			server.server_info_updated.emit(new_server)
		else:
			server.status = "inactive"
			server.server_info_updated.emit(server)
	else:
			server.status = "inactive"
			server.server_info_updated.emit(server)


func wait_before_requesting():
	while ahttp.is_requesting:
		await ScreepsHTTP.ahttp.request_finished
