extends Node2D

const PARTICLE_COOLDOWN = 20

var child_array : Array

var cooldown = 1000

onready var child_count = self.get_child_count()

onready var index = 0


func _ready():
	child_array = []
	for i in range(0, child_count):
		child_array.append(self.get_child(i))

func _process(_delta):
	cooldown += 1
	if(cooldown > 1000):
		cooldown = 1000

func _on_land():
	emit()
	
func _on_jump():
	emit()

func emit():
	if(!child_array[index].emitting && cooldown > PARTICLE_COOLDOWN):
		child_array[index].restart()
		
		index += 1
		if(index >= child_count):
			index = 0
		
		cooldown = 0
