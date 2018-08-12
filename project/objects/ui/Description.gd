extends Label

onready var _bioContainer = $"../../.."

func _ready():
	_bioContainer.connect("ViewBioSignal", self, "_setBio")

func _setBio(bioObj):
	self.text = bioObj.Bio