extends Control

var CHOICES_PREFIX = "choix_"
var choices_names := ["tel_ouvert", "mdr", "addiction"]
var choices_values := []
var choices := {}

var GAUGE_PREFIX = "jauge_"
var gauges_names := ["travail", "education", "financier", "ecologie", "social"]
var gauges_ranges := [[-11, 22], [-9, 27],   [-23, 24],   [-13, 13],  [-19, 20]]
var gauges_values := []
var gauges := {}

var RELATIONS_PREFIX = "relation_"
var relations_names := ["evelyne", "jm"]
var relations_ranges := [[-5, 6],  [-3, 5]]
var relations_values := []
var relations := {}


func _ready() -> void:
	_recover_variables()
	gauges_values = _get_percentages(gauges, gauges_names, gauges_ranges)
	relations_values = _get_percentages(relations, relations_names, relations_ranges)
	choices_values = _get_choices_array()


func _recover_variables():
	var definitions = Dialogic.get_definitions()
	# Get relations and gauges from variables
	for d in definitions["variables"]:
		for g in gauges_names:
			if d["name"] == GAUGE_PREFIX + g:
				gauges[g] = d
		for r in relations_names:
			if d["name"] == RELATIONS_PREFIX + r:
				relations[r] = d
		for c in choices_names:
			if d["name"] == CHOICES_PREFIX + c:
				choices[c] = d
	print(choices)


func _get_percentages(data: Dictionary, names: Array, ranges: Array) -> Array:
	var final_array := []
	for i in range(0, data.size()):
		var val = float(data[names[i]]["value"])
		var min_max = ranges[i]
		# Adjust offset
		val -= min_max[0]
		# Get whole range
		var total_range = min_max[1] - min_max[0]
		final_array.append(100 * val / total_range)
	return final_array


func _get_choices_array() -> Array:
	var final_array := []
	for i in range(0, choices.size()):
		final_array.append(choices[choices_names[i]]["value"])
	return final_array
