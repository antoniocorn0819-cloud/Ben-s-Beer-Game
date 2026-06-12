class_name Numbers extends Control

@export var beer_label: Label
@export var coin_label: Label

func gui_update(data: GameData):
	beer_label.text = "beers per minute: " + str(data.bpm)
	coin_label.text = "coins: " + str(data.coins)
	
