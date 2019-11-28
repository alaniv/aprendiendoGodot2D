extends Node2D

var overworld_song_intro = load("res://Audio/Music/Overworld_Intro.ogg") #estas son muy usadas, las mantengo...
var overworld_song = load("res://Audio/Music/Overworld.ogg")

onready var MainSong = $Song
onready var SFX = $SFX

signal sfx_finished

func _ready():
	SFX.connect("finished", self, "emit_signal", ["sfx_finished"])
	# play_song("NayruSong") # DEV

func play_song(name):
	var song = null
	match name:
		"Overworld":
			if not MainSong.playing:
				MainSong.stream = overworld_song_intro
				MainSong.playing = true
				yield(MainSong, "finished")
				MainSong.stream = overworld_song
				MainSong.playing = true
				return
		"ImpaOddArrival":
			song = load("res://Audio/Music/Fairies Fountain  Impas Odd Arrival.ogg")
		"NayruSong":
			song = load("res://Audio/Music/NayrusSong.ogg")
		"OddHappening":
			song = load("res://Audio/Music/OddHappening.ogg")
		"RoomOfRites":
			song = load("res://Audio/Music/RoomOfRites.ogg")
		"SadTheme":
			song = load("res://Audio/Music/SadTheme.ogg")
	MainSong.stream = song
	MainSong.playing = true
			
func stop_song():
	MainSong.playing = false
			
func play_sfx(name):
	var sfx = null
	match name:
		"BeginQuest":
			sfx = load("res://Audio/SFX/Others/Oracle_BeginQuest.wav")
		"Tap":
			sfx = load("res://Audio/SFX/Sword/Tap.wav")
		"Throw":
			sfx = load("res://Audio/SFX/Link/Throw.wav")
		"Slash1":
			sfx = load("res://Audio/SFX/Sword/Slash1.wav")
		"Slash2":
			sfx = load("res://Audio/SFX/Sword/Slash2.wav")
		"Slash3":
			sfx = load("res://Audio/SFX/Sword/Slash3.wav")
		"Spin":
			sfx = load("res://Audio/SFX/Sword/Spin.wav")
		"BossDie":
			sfx = load("res://Audio/SFX/Boss/BossDie.wav")
		"Lightning":
			sfx = load("res://Audio/SFX/Others/Lightning.wav")
		"Fanfare":
			sfx = load("res://Audio/SFX/Link/FanfareItem.wav")
		"Rumble1":
			sfx = load("res://Audio/SFX/Others/Rumble1.wav")
		"DungeonTeleport":
			sfx = load("res://Audio/SFX/Others/DungeonTeleport.wav")
		"Shimmer":
			sfx = load("res://Audio/SFX/Sword/Shimmer.wav")
		"EnemyDie":
			sfx = load("res://Audio/SFX/Enemy/EnemyDie.wav")
			
	SFX.stream = sfx
	SFX.playing = true