class_name PlantData extends Resource

enum ANIMATION_STRATEGY { ALGAE, WALL_STALK, WALL_LEAF, BULB }

@export var value: int = 0
@export var animation: ANIMATION_STRATEGY = ANIMATION_STRATEGY.ALGAE
