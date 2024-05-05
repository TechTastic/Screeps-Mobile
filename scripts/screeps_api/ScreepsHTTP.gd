extends Node

func send_request(url: String, test: Callable = func(): pass, headers: PackedStringArray = PackedStringArray(), method: HTTPClient.Method = HTTPClient.METHOD_GET, request: String = ""):
	# Create and add new HTTPRequest node
	var http = HTTPRequest.new()
	add_child(http)
	
	# Call test upon request completed
	http.request_completed.connect(test)
	
	# Send request
	http.request(url, headers, method, request)
	
	# Pause thread and await request handling completion
	await http.request_completed
	
	# Remove HTTP node
	remove_child(http)
	http.queue_free()

func get_http_url(server: ScreepsServer):
	var url = ""
	
	# If secure, use HTTPS
	if server.secure:
		url += "https://"
	else:
		url += "http://"
	url += server.host
	# If port specified, use port
	if server.port != -1:
		url += ":" + str(server.port)
	url += "/"
	
	return url


func get_server_version_data(server: ScreepsServer, callback: Signal):
	# https://screeps.com/api/version
	var url = get_http_url(server) + "api/version"
	
	# Test response and respond accordingly
	var test = func(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
		var json = JSON.parse_string(body.get_string_from_utf8())
		# If response is 200 and JSON readable, set data
		if response_code == 200 and json != null:
			callback.emit(json.duplicate())
		else:
			print(result)
			print(response_code)
			print(headers)
			print(body.get_string_from_utf8())
	
	# Send request and await method completion
	await send_request(url, test)

func get_community_server_list(callback: Signal):
	var url = "https://screeps.com/api/servers/list"
	
	# Test response and respond accordingly
	var test = func(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray): 
		var json = JSON.parse_string(body.get_string_from_utf8())
		print("Community Server List")
		# If response is 200 and JSON readable, set data
		if response_code == 200 and json != null and !json.has("error"):
			print("Got Server!")
			var servers = json.servers
			var server_list = []
			for index in servers.size():
				var server_json = servers[index]
				var server = ScreepsServer.new()
				server.set_server_properties(
					server_json.name, 
					server_json.settings.host, 
					int(server_json.settings.port),
					"",
					true,
					server_json.likeCount,
					server_json.status == "active"
					)
				server.has_likes = true
				server_list.push_back(server)
			callback.emit(server_list)
		else:
			print(result)
			print(response_code)
			print(headers)
			print(body.get_string_from_utf8())
	
	# Send request and await method completion
	await send_request(url, test, PackedStringArray(), HTTPClient.METHOD_POST)
