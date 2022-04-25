extends Node

const DEFAULT_IP = '192.168.188.30'
const DEFAULT_PORT = 31412
const MAX_PLAYERS = 5

signal createdServer
signal playerJoinedServer
signal playerDisconnectedServer

var created = false

var playerList = [1]

func create_server():
	print("creating server...")
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(DEFAULT_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(peer)
	
	get_tree().connect('network_peer_disconnected', self, '_on_player_disconnected')
	get_tree().connect('network_peer_connected', self, '_on_player_connected')
	
	created = true
	emit_signal("createdServer")

func _on_player_disconnected(id):
	emit_signal("playerDisconnectedServer", id)
	playerList.erase(id)

func _on_player_connected(id):
	emit_signal("playerJoinedServer", id, playerList)
	playerList.append(id)



func _ready():
	self.pause_mode = PAUSE_MODE_PROCESS
	get_tree().paused = true


func _input(event):
	if Input.is_action_just_pressed("ui_down"):
		Server.create_server()
		get_tree().paused = false
		get_node(Globals.blurOverlay).unblur1()
	elif Input.is_action_just_pressed("ui_up"):
		Connector.connect_to_server()
		get_tree().paused = false
		get_node(Globals.blurOverlay).unblur2()
