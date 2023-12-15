extends Control

const healing_size = 10
const hurt_size = 3
const healing_delay = 0.7
var is_healing = true
var time = 0
var start = Time.get_ticks_msec()

# Called when the node enters the scene tree for the first time.
func _ready():
	var lamps = get_tree().get_nodes_in_group("lamp")
	if lamps.size() > 0:
		lamps[0].connect("start_healing", heal_up, CONNECT_DEFERRED)
		lamps[0].connect("stop_healing", stop_heal, CONNECT_DEFERRED)

func _process(delta):
	time += delta
	
	if(time >= healing_delay):
		time -= healing_delay
		if(is_healing):
			$ProgressBar.value += healing_size
		else:
			$ProgressBar.value -= hurt_size
		
	

func heal_up():
	if($ProgressBar.value < 100):
		is_healing = true

func stop_heal():
	is_healing = false
