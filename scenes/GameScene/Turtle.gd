class_name Turtle extends Animal

var edible_plants = []
var current_plant_eating:GenericPlant
var eating_timer = 0
var eating_time = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	
	if edible_plants.size() > 0:
		if current_plant_eating == edible_plants[0] && not current_plant_eating.is_queued_for_deletion():
			# same plant, carry on eating
			eating_timer += delta
			if eating_timer > eating_time:
				_eat_plant(current_plant_eating)
		else:
			# NEW PLANT WHO DIS
			current_plant_eating = edible_plants[0]
			eating_timer = 0
		# start eating animation
	else:
		# stop eating animation
		pass

func _eat_plant(plant:GenericPlant):
	GameState.score -= plant.data.value
	edible_plants.erase(plant)
	eating_timer = 0
	plant.queue_free()

func _on_plant_collision_area_entered(area):
	var area_parent = area.get_parent()
	if area_parent is GenericPlant:
		var plant:GenericPlant = area_parent
		edible_plants.append(plant)
		#print(edible_plants.size())

func _on_plant_collision_area_exited(area):
	var area_parent = area.get_parent()
	if area_parent is GenericPlant:
		var plant:GenericPlant = area_parent
		edible_plants.erase(plant)
		#print(edible_plants.size())
