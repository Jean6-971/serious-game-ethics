tool
extends HBoxContainer


export(String) var title: String = ""
export(String) var subtile: String = ""
export(String) var link: String = ""


func _ready():
	$HBoxContainer/Title.text = title
	$HBoxContainer/Subtitle.text = subtile
	if not link.empty():
		$LinkButton.show()


func _on_LinkButton_pressed():
	OS.shell_open(link)
