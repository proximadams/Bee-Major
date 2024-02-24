extends Node

func valve_array_to_str(valveArr):
	var valveStr = ''
	if valveArr[0]:
		valveStr += '_ '
	else:
		valveStr += 'T '
	if valveArr[1]:
		valveStr += '_ '
	else:
		valveStr += 'T '
	if valveArr[2]:
		valveStr += '_'
	else:
		valveStr += 'T'
	return valveStr
