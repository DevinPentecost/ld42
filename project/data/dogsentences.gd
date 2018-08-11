extends Node

# https://godot.readthedocs.io/en/3.0/getting_started/scripting/gdscript/gdscript_format_string.html
# Defined replacer tokens:
	# {name}
	# {girl}
	# {she}
	# {her}
	# {do} direct object, her/him
	# {age}
	# {adjective}
	# {objects}

export var IntroSentences = ["Meet {name}, this {adjective} {girl} is looking for {her} best friend to grab a pup-achino with.",
"This {adjective} {girl} wants nothing more than to bond to your lap.",
"{name} is very loving and {adjective}.",
"{name} was rescued from a different shelter where {she} landed after being found stray.",
"{name} is about as {adjective} as puppies come!",
"{name} is {adjective} and gets along well with kids, other dogs and even cats.",
"{name} may be the runt of {her} litter but that doesnt stop {her} from keeping up with the rest!",
"This {age} old little {girl} is ready to meet {her} new best friend and go on all sorts of adventures together.",
"{name} is an {adjective} puppy who is about {age}s old.",
"{name} is a great puppy who is very energetic and {adjective}.",
"{name} is a very {adjective} little {girl} that is ready to give and receive love, {she} is just shy at first.",
"{name} is very {adjective} after {she} gets to know you.",
"{name} is a cuddly and {adjective} dog.",
"{name} is very {adjective} and cuddly and just wants a pal to spend the rest of {her} life with!",
"{name} can protect your home and {objects} like nobody's business!",
"{name} is an experienced, but {adjective}, hunter of {objects}.",
"This {adjective} {girl} used to be a show dog!",
"This {adjective} {girl} is very popular with visitors!",
"{name} has some special needs, and would love to join a caring family.",
"{name} prefers relaxing on the couch on hot days.",
"This {age} old pup bonds quickly to {adjective} humans, but {she} is very skittish around {objects}."]

export var OutroSentences = ["{she} is already housebroken and crate trained.",
"{she} loves going everywhere with {her} humans and does well in the car.",
"It doesnt get much better than this bundle of love.",
"{she} loves one on one attention yet {she} plays with the other resident dogs here just fine.",
"{she} is nicely potty trained and does not mark indoors at all.",
"{she} doesn't run; {she} bounces!",
"{she} bonds strongly with {objects}.",
"This sweet {girl} makes everyone smile.",
"{she} loves playing with other puppies and exploring new things.",
"{she} would love to explore {her} forever home!",
"{she} has also found that being the smallest and sweetest is getting {her} the most cuddles and {she} does love to snuggle!",
"{she} would love an active owner who takes {her} on plenty of walks and adventures.",
"{she} still has all of {her} puppy energy and is very happy with anyone willing to give {her} time and attention!",
"{she} wanted us to let y'all know {she} enjoys long walks anywhere and chasing down squirrels!",
"{she} is a special pup because {she} has some neurological issues.",
"{she} doesn't let {her} quirks slow {her} down, {she} is very active and loves to explore.",
"{her} new family will need to take precautions for {her} safety, especially around stairs and {objects}.",
"{she} would like a home where someone is around frequently and {she} gets to spend majority of {her} time outside in a yard or a room where {she} can play.",
"{she} sleeps through the night in {her} crate but is still working on potty training.",
"{she} will get into your lap and give you snuggles and kisses but is content with a belly rub.",
"{she}'s pretty good on potty training and would love your help to continue!",
"{she} is not food aggressive in fact {she} will go to {her} spot and wait for {her} bowl to be placed.",
"{she} has also learned about playing with {objects} and sharing with other dogs.",
"{she} loves to get up on the end table and lay in the sun or just look out the window.",
"Changes are very scary for {do} and {she} doesn't like a lot of people around {do}.",
"{she} is learning to trust again and is doing very well.",
"{she} bonds quickly to one person.",
"{she} plays well with small dogs, don't know about cats.",
"{she} is a little shy at first but once {she} feels comfortable and knows you, {she} will be ok.",
"{she} loves belly rubs, {she} will roll on {her} back and beg for belly rubs.",
"{she} doesn't want to get out of bed unless {she} feels like it's justified.",
"{she}'s fascinated by {objects}.",
"{she} needs to be watched carefully around {objects}.",
"{name} loves to play with {objects}!"]