extends Node

const SAVE_PATH = "user://savegame.sav"
const SECRET = "C220 Is the Best!"
var save_file = ConfigFile.new()

onready var HUD = get_node_or_null("/root/Game/UI/HUD")
onready var Game = load("res://Game.tscn")
onready var Level2 = load("res://Level2.tscn")


var save_data = {
	"general": {
		"score":0
		,"health":100
	},
	"player":{
		"position_x":0,
		"position_y":0
	},
	"enemies":[]
	}


func _ready():
	update_score(0)
	update_health(0)
	

func update_score(s):
	save_data["general"]["score"] += s
	HUD = get_node_or_null("/root/Game/UI/HUD")
	if HUD != null:
		HUD.find_node("Score").text = "Score: " + str(save_data["general"]["score"])

func update_health(h):
	save_data["general"]["health"] += h
	HUD = get_node_or_null("/root/Game/UI/HUD")
	if HUD != null:
		HUD.find_node("Health").text = "Health: " + str(save_data["general"]["health"])

func restart_level():
	HUD = get_node_or_null("/root/Game/UI/HUD")
	update_score(0)
	update_health(0)
	if save_data["player"]["position_x"] != 0:
		var player_container = get_node_or_null("/root/Game/Player_Container")
		if player_container != null:
			player_container.spawn(Vector2(save_data["player"]["position_x"],save_data["player"]["position_y"]))
	save_data["enemies"] = []
	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		var found = false
		print(save_data["enemies"])
		for s_enemy in save_data["enemies"]:
			if s_enemy["name"] == enemy.name:
				found = true
				enemy.position.x = s_enemy["position_x"]
				enemy.position.y = s_enemy["position_y"]
				enemy.health = s_enemy["health"]
		if not found:
			enemy.queue_free()
	get_tree().paused = false

# ----------------------------------------------------------
	
func save_game():
	var player = get_node_or_null("/root/Game/Player_Container/Player")
	if player != null:
		save_data["player"]["position_x"] = player.global_position.x
		save_data["player"]["position_y"] = player.global_position.y
	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		var temp = {}
		temp["position_x"] = enemy.global_position.x
		temp["position_y"] = enemy.global_position.y
		temp["name"] = enemy.name
		temp["health"] = enemy.health
		save_data["enemies"].append(temp)
	var save_game = File.new()						# create a new file object
	save_game.open_encrypted_with_pass(SAVE_PATH, File.WRITE, SECRET)	# prep it for writing to, make sure the contents are encrypted
	save_game.store_string(to_json(save_data))				# convert the data to a json representation and write it to the file
	save_game.close()							# close the file so other processes can read from or write to it
	
func load_game():
	var save_game = File.new()						# Create a new file object
	if not save_game.file_exists(SAVE_PATH):				# If it doesn't exist, skip the rest of the function
		return
	save_game.open_encrypted_with_pass(SAVE_PATH, File.READ, SECRET)	# The file should be encrypted
	var contents = save_game.get_as_text()					# Get the contents of the file
	save_data = parse_json(contents)
	var _scene = get_tree().change_scene_to(Game)				# Load the scene
	call_deferred("restart_level")						# When it's done being loaded, call the restart_level method
