# +
import json
def get_labels_json(file):
    lst_labels=[]
    with open(file, "rt") as f:
        dict1 = json.load(f)
        #print(dict1)
        #print(len(dict1['annotationResults'][0]['segmentLabelAnnotations']))
        for segment in dict1['annotationResults'][0]['segmentLabelAnnotations']:
            print(segment['entity']['description'])
            lst_labels.append(segment['entity']['description'])
        
        return lst_labels
        
#print(get_labels_json("Output/Tesla - Revolutionize Your Commute.mp4.json"))
