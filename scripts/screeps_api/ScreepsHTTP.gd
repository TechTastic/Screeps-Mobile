extends Node

var http = HTTPRequest.new()
var request_queue = []
var request_queued = false

func _ready():
	add_child(http)
	http.use_threads = true

func _process(_delta):
	if request_queue.size() > 0 and !request_queued:
		request_queued = true
		var request = request_queue.pop_front()
		var failure = func(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
			if result != 0 or response_code < 200 or response_code >= 300:
				request_queue.push_back(request)
			else:
				request.test.call(headers, body)
		
		http.request_completed.connect(failure)
		http.request(request.url, request.headers, request.method, request.body)
		await http.request_completed
		http.request_completed.disconnect(failure)
		request_queued = false

func add_request_to_queue(url: String, test: Callable = func(headers: PackedStringArray, body: PackedByteArray): pass, headers: PackedStringArray = PackedStringArray(), method: HTTPClient.Method = HTTPClient.METHOD_GET, body: String = ""):
	var request = { "url": url, "test": test, "headers": headers, "method": method, "body": body }
	if (request_queue.count(request) == 0):
		request_queue.append(request)

func get_http_url(server: ScreepsServer):
	var url = ""
	
	# If secure, use HTTPS
	if server.secure:
		url += "https://"
	else:
		url += "http://"
	url += server.host
	# If port specified, use port
	if server.port != "":
		url += ":" + server.port
	url += "/"
	
	return url


func get_community_server_list(callback: Signal):
	var url = "https://screeps.com/api/servers/list"
	
	# Test response and respond accordingly
	var test = func(headers: PackedStringArray, body: PackedByteArray): 
		var json = JSON.parse_string(body.get_string_from_utf8())
		# If response is 200 and JSON readable, set data
		if json != null and !json.has("error") and json.has("servers"):
			var servers = json.servers
			var server_list = []
			for index in servers.size():
				var server = ScreepsServer.new()
				server.read_from_server_list(servers[index])
				server_list.push_back(server)
			callback.emit(server_list)
		else:
			print("Failed to get servers for Community Server List!")
			print(headers)
			print(body.get_string_from_utf8())
	
	# Send request and await method completion
	add_request_to_queue(url, test, PackedStringArray(), HTTPClient.METHOD_POST)
