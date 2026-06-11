class_name Numbers extends Control

@export var beer_label: Label


func gui_update(data: GameData):
	beer_label.text = "beers: " + str(data.total_beers)
	
