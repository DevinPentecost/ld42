extends Node

export var Name = "name"
export var Bio = "bio"


const namesP = preload("res://data/dognames.gd")
const adjectivesP = preload("res://data/dogadjectives.gd")
const sentencesP = preload("res://data/dogsentences.gd")
const objectsP = preload("res://data/dogobjects.gd")

const sexes = ["girl", "boy"]
const swapHer = ["her", "his"]
const swapShe = ["she", "he"]


func _ready():
	randomize()
	
	var names = namesP.new()
	var adjectives = adjectivesP.new()
	var sentences = sentencesP.new()
	var objects = objectsP.new()
	
	var sexIndex = randi()%(sexes.size())
	
	var sex = sexes[sexIndex].to_lower()
	var her = swapHer[sexIndex].to_lower()
	var she = swapShe[sexIndex].to_lower()
	
	var ageMonths = randi()%120
	var ageStr = str(ageMonths) + " month"
	if ageMonths > 20:
		ageStr = str(ageMonths / 12) + " year"
	
	if sexIndex == 0:
		Name = _titleCase(names.GirlNames[randi()%(names.GirlNames.size())])
	else:
		Name = _titleCase(names.BoyNames[randi()%(names.BoyNames.size())])
	
	var adjective = adjectives.AllAdjectives[randi()%(adjectives.AllAdjectives.size())].to_lower()
	var object = objects.AllObjects[randi()%(objects.AllObjects.size())].to_lower()
	var swapper = {"name": Name, "girl": sex, "she": she, "her": her, "age": ageStr, "adjective": adjective, "objects": object}
	
	var intro = sentences.IntroSentences[randi()%(sentences.IntroSentences.size())].format(swapper)
	
	# redo randoms
	adjective = adjectives.AllAdjectives[randi()%(adjectives.AllAdjectives.size())].to_lower()
	object = objects.AllObjects[randi()%(objects.AllObjects.size())].to_lower()
	swapper = {"name": Name, "girl": sex, "she": she, "her": her, "age": ageStr, "adjective": adjective, "objects": object}
	
	var outroAIndex = randi()%(sentences.OutroSentences.size())
	var outroA = sentences.OutroSentences[outroAIndex].format(swapper)
	
	Bio = _titleCase(intro) + " " + _titleCase(outroA)
	
	# Add a third sentence sometimes. Don't stutter.
	var outroBIndex = randi()%(sentences.OutroSentences.size())
	if outroBIndex > outroAIndex:
		# redo randoms
		adjective = adjectives.AllAdjectives[randi()%(adjectives.AllAdjectives.size())].to_lower()
		object = objects.AllObjects[randi()%(objects.AllObjects.size())].to_lower()
		swapper = {"name": Name, "girl": sex, "she": she, "her": her, "age": ageStr, "adjective": adjective, "objects": object}
		
		var outroB = sentences.OutroSentences[outroBIndex].format(swapper)
		Bio = Bio + " " + _titleCase(outroB)
	
	pass
	
func _titleCase(s):
	return s.left(1).to_upper() + s.substr(1, s.length()-1)