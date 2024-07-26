extends Area2D

func _ready():
	self.connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body.name == "bird":
		print('ground')
