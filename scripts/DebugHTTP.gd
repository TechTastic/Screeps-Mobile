extends Panel

@onready var url = $HBoxContainer/Panel/URL
@onready var method = $HBoxContainer/Panel/METHOD
@onready var headers = $HBoxContainer/Panel/CodeEdit2
@onready var body = $HBoxContainer/Panel/CodeEdit

@onready var http = $HTTPRequest

@onready var response_result = $HBoxContainer/Panel2/RESULT
@onready var response_code = $"HBoxContainer/Panel2/RESPONSE CODE"
@onready var response_headers = $HBoxContainer/Panel2/ScrollContainer/Label
@onready var response_body = $HBoxContainer/Panel2/ScrollContainer2/Label

func _on_button_pressed():
	http.request(url.text, get_headers(), get_method(), body.text)

func get_method():
	match method.text:
		"POST":
			return HTTPClient.METHOD_POST
	return HTTPClient.METHOD_GET

func get_headers():
	var json = JSON.parse_string(headers.text)
	if json == null:
		return PackedStringArray()
	return json

func get_body():
	if body.text == null:
		return ""
	return body.text

func _on_http_request_request_completed(result, response_code, headers, body):
	self.response_result.text = str(result)
	self.response_code.text = str(response_code)
	self.response_headers.text = JSON.stringify(headers, "    ")
	self.response_body.text = JSON.stringify(JSON.parse_string(body.get_string_from_utf8()), "    ")
