extends Node


onready var playerTscn = load("res://scenes/Players/Player.tscn")

func _ready():
	Server.connect("playerJoinedServer", self,"_on_player_joined_server")
	Server.connect("playerDisconnectedServer", self, "_on_player_disconnected_server")

remote func _register_player(id):
	print("New Player arrived: " + str(id))
	var p = playerTscn.instance()
	p.isPuppet = true
	p.name = str(id)
	p.id = id
	#p.set_network_master(multiplayer.get_network_unique_id())
	add_child(p)
	
sync func _unregister_player(id):
	print("Player removed: " + str(id))
	get_node(str(id)).queue_free()

func _register_self():
	rpc("_register_player", multiplayer.get_network_unique_id())

func _on_player_disconnected_server(id):
	rpc("_unregister_player", id)


func _on_player_joined_server(id, idList):
	rpc_id(id, "registerAllPlayers", idList)

remote func registerAllPlayers(idList):
	print("registering all players...")
	for id in idList:
		print("Player registered: " + str(id))
		var p = playerTscn.instance()
		p.isPuppet = true
		p.name = str(id)
		p.id = id
		#p.set_network_master(id)
		add_child(p)
	_register_self()
	print(idList)
