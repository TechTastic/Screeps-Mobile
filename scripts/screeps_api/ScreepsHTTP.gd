extends Node

var http = HTTPRequest.new()
var request_queue = []
var request_queued = false
var ahttp: AwaitableHTTPRequest = AwaitableHTTPRequest.new()

func _ready():
	add_child(http)
	http.use_threads = true
	
	add_child(ahttp)
	ahttp.timeout = 5.0

func _process(_delta):
	if request_queue.size() > 0 and !request_queued:
		request_queued = true
		var request = request_queue.pop_front()
		var failure = func(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
			if result != 0 or response_code < 200 or response_code >= 300:
				print(request.server.host)
				print(result)
				print(response_code)
				print(headers)
				print(body.get_string_from_utf8())
				
				if result == 5:
					request.server.secure = false
				if response_code == 404 or result == 2:
					return
				request_queue.push_back(request)
			else:
				request.test.call(headers, body)
		
		http.request_completed.connect(failure)
		http.request(request.server.get_http_url(request.path), request.headers, request.method, request.body)
		await http.request_completed
		http.request_completed.disconnect(failure)
		request_queued = false

func add_request_to_queue(server: ScreepsServer, path: String, test: Callable = func(headers: PackedStringArray, body: PackedByteArray): pass, headers: PackedStringArray = PackedStringArray(), method: HTTPClient.Method = HTTPClient.METHOD_GET, body: String = ""):
	var request = { "server": server, "path": path, "test": test, "headers": headers, "method": method, "body": body }
	if (request_queue.count(request) == 0):
		request_queue.append(request)

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
	var url = server.get_http_url("api/version")
	
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
