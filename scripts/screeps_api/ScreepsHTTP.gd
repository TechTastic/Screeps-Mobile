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


func get_room_status(server: ScreepsServer, room: String):
	# https://screeps.com/api/game/room-status?room=E1N8
	var url: String = server.get_http_url("api/game/room-status?room=" + room)
	
	await wait_before_requesting()
	var r := await ahttp.async_request(url)
	
	if r.success:
		print(JSON.stringify(r.json, "    "))


func authenticate(server: ScreepsServer, json: Dictionary):
	#[POST] https://screeps.com/api/auth/signin
		#post data: { email, password }
		#response: { ok, token }
#
	#[POST] https://screeps.com/api/auth/steam-ticket
		#post data: { ticket, useNativeAuth }
#
	#[POST] https://screeps.com/api/auth/query-token
		#post data: { token }
	await wait_before_requesting()
	print(server.mods)
	print(server.use_native_auth)
	if json.has("signin"):
		var r := await ahttp.async_request(server.get_http_url("api/auth/signin"), HTTPClient.METHOD_POST, ["Content-Type: application/json"], JSON.stringify(json.get("signin")))
	
		if r.success:
			print(r.body)
	elif json.has("steam"):
		var r := await ahttp.async_request(server.get_http_url("api/auth/steam-ticket"), HTTPClient.METHOD_POST, ["Content-Type: application/json"], JSON.stringify(json.get("steam-ticket")))
	
		if r.success:
			print(JSON.stringify(r.json, "    "))
	elif json.has("token"):
		var r := await ahttp.async_request(server.get_http_url("api/auth/query-token"), HTTPClient.METHOD_POST, ["Content-Type: application/json"], JSON.stringify(json.get("token")))
	
		if r.success:
			print(JSON.stringify(r.json, "    "))
	pass


func wait_before_requesting():
	while ahttp.is_requesting:
		await ScreepsHTTP.ahttp.request_finished
