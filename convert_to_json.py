import xml.etree.ElementTree as et
import json

def parse_mei_file(path):
    # parsing the MEI file and get the root element
    tree = et.parse(path)
    root = tree.getroot()

    # namespace dictionary for MEI elements
    ns = {"mei": 'http://www.music-encoding.org/ns/mei'}

    # finding all <note> and <rest> elements within <layer>
    notes_rests = root.findall('.//mei:layer/mei:(note|rest)', ns)

    # initializing list to hold note data
    note_data = []

    for elem in notes_rests:
        if elem.tag == "rest":
            # if rest element, append [0, duration] to note_data
            note_data.append([0, int(elem.attrib["dur"])])
        elif elem.tag == "note":
            # if note element, parse its attributes
            # mapping pitch names to corresponding indices
            pitch_mapping = {"c": 1, "c#": 2, "d": 3, "d#": 4, "e": 5, 
                             "f": 6, "f#": 7, "g": 8, "g#": 9, "a": 10, 
                             "a#": 11, "b": 12}
            step = elem.attrib["pname"].lower()
            octave = int(elem.attrib["oct"]) - 4 # offset to make c4 index 0
            duration = int(elem.attrib["dur"])
            # calculating index of the note based on pitch and octave
            note_index = pitch_mapping[step] + (octave * 12)
            note_data.append([note_index, duration])

    return note_data

def convert_to_json(note_data, output_file):
    # converting note_data to JSON format and writing to output_file
    with open(output_file, "w") as f:
        json.dump(note_data, f, indent=4)

if __name__ == "__main__":
    # specify input MEI file path and output JSON file path
    mei_file_path = "C:/Users/gilis/OneDrive/Documents/GitHub/Bee-Major/Bee_Major_Jazz_Song.mei"
    json_output_path = "C:/Users/gilis/OneDrive/Documents/GitHub/Bee-Major/"

    # parse the MEI file and get note data
    parsed_data = parse_mei_file(mei_file_path)

    # convert note data to JSON format and write to output file
    convert_to_json(parsed_data, json_output_path)
