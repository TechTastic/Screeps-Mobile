extends Control

var server: ScreepsServer

func _on_login_input_login(username, password):
	print("Logging in!", "\n" + username, "\n" + password)
	
	var login = {
		"signin": {
			"email": username,
			"password": password
		}
	}
	
	await ScreepsHTTP.authenticate(server, login)


func _on_login_input_register(username, password):
	print("Registering!", "\n" + username, "\n" + password)
