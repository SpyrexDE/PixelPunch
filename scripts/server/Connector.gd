extends Node

signal selfJoined
signal otherJoined

const DEFAULT_PORT = 31412

var local_address : String
var connected = false

var dataFileContent = {}

func _ready():
	for add in IP.get_local_addresses():
		add = add as String
		if add.begins_with("192."):
			local_address = add
	
	get_tree().multiplayer.connect('connected_to_server', self, '_connected_to_server')
	get_tree().multiplayer.connect('network_peer_packet', self, '_on_packet_received')
	get_tree().multiplayer.connect('connection_failed', self, '_on_connection_failed')

func connect_to_server():
	print("connecting...")
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(local_address, DEFAULT_PORT)
	get_tree().set_network_peer(peer)

func _connected_to_server():
	print("connected!")
	emit_signal("selfJoined")
	connected = true

func readDataFile():
	var file = File.new()
	file.open("res://data/Data.json", file.READ)
	var text = file.get_as_text()
	dataFileContent = JSON.parse(text).result
	file.close()

func _on_connection_failed():
	print("connection failed")
	Server.create_server()
	connect_to_server()
