extends Spatial

signal adopted

#Debbing
var _debugging = false

#Properties of doggo
const SCALE_RANGE = Vector2(0.8, 1.5)
const TEND_RATE_RANGE = Vector2(0.1, 0.15)
const ADOPTION_RATE_RANGE = Vector2(0.1, 0.15)
const COLOR_RANGE = {
	'r': Vector2(0, 1),
	'g': Vector2(0, 1),
	'b': Vector2(0, 1)
}
export(Texture) var TEXTURE_A
export(Texture) var TEXTURE_B
onready var TEXTURES = [TEXTURE_A, TEXTURE_B]

#All the various properties of a dog
export(String) var dog_name
export(String) var description = "This hound needs a description!"
export(float) var dog_scale
export(Texture) var base_texture
export(Color) var tint
export(float) var tend_rate
export(float) var adoption_rate

var bio

#Properties of the dog's status
const MIN_START_HAPPINESS = 0.1
const MAX_START_HAPPINESS = 0.8
const MIN_ADOPTION_HAPPINESS = 0.6
var happiness = rand_range(MIN_START_HAPPINESS, MAX_START_HAPPINESS)
var adoption = 0

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	
	# Generate a bio
	self.find_node("Biography").connect("BioGenerationDone", self, "_bio_ready")
	
	#Create the model and stuff here
	
	set_process(true)
	
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	
	_update_status(delta)
	
	#Debug
	if _debugging:
		print('a ', adoption, ' h ', happiness)
	$AdoptSprte.modulate.r = adoption
	$HappySprite.modulate.r = happiness

func _bio_ready():
	bio = self.find_node("Biography")
	dog_name = bio.Name
	description = bio.Bio

func _update_status(delta):
	
	#Lower the happiness by the tend rate
	happiness -= tend_rate * delta
	happiness = max(happiness, 0)
	
	#Are we happy enough to start getting adopted?
	if happiness >= MIN_ADOPTION_HAPPINESS:
		adoption += adoption_rate * delta
		
		#Are we super happy?!
		if adoption >= 1:
			#Someone adopted us
			emit_signal("adopted")
			set_process(false)
		
func feed():
	#The dog is fed and happy!
	happiness = 1