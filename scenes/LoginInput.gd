extends VBoxContainer

signal login(username: String, password: String)
signal register(username: String, password: String)

@onready var username = $UsernameLine
@onready var password = $PasswordLine


func _on_login_button_pressed():
	login.emit(username.text, password.text)


func _on_register_button_pressed():
	register.emit(username.text, password.text)
