extends Node

export var Name = "name"
export var Bio = "bio"


const namesP = preload("res://data/dognames.gd")
const adjectivesP = preload("res://data/dogadjectives.gd")
const sentencesP = preload("res://data/dogsentences.gd")

const sexes = ["girl", "boy"]
const swapHer = ["her", "his"]
const swapShe = ["she", "he"]


func _ready():
	randomize()
	
	var names = namesP.new()
	var adjectives = adjectivesP.new()
	var sentences = sentencesP.new()
	
	var sexIndex = randi()%(sexes.size())
	
	var sex = sexes[sexIndex].to_lower()
	var her = swapHer[sexIndex].to_lower()
	var she = swapShe[sexIndex].to_lower()
	
	var ageMonths = randi()%120
	var ageStr = str(ageMonths) + " months"
	if ageMonths > 20:
		ageStr = str(ageMonths / 12) + " years"
	
	var adjective = adjectives.AllAdjectives[randi()%(adjectives.AllAdjectives.size())].to_lower()
	
	if sexIndex == 0:
		Name = _titleCase(names.GirlNames[randi()%(names.GirlNames.size())])
	else:
		Name = _titleCase(names.BoyNames[randi()%(names.BoyNames.size())])
	
	var swapper = {"name": Name, "girl": sex, "she": she, "her": her, "age": ageStr, "adjective": adjective}
	var intro = sentences.IntroSentences[randi()%(sentences.IntroSentences.size())].format(swapper)
	var outro = sentences.OutroSentences[randi()%(sentences.OutroSentences.size())].format(swapper)
	
	Bio = _titleCase(intro) + " " + _titleCase(outro)
	pass
	
func _titleCase(s):
	return s.left(1).to_upper() + s.substr(1, s.length()-1)