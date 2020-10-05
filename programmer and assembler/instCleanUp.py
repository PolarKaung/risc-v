def stripComment(string):
    hashLoc = string.find("#")
    return string[0:hashLoc].rstrip()

def cleanUp(list_):
    newList = [];
    list_ = [stripComment(i) for i in list_]
    for i in list_:
        if (i != ''):
            newList.append(i)
    return newList

def containLabel(list_):
    labelList = []
    for i in list_:
        labelIdentifier = i.find(":")
        if (labelIdentifier > 0):
            labelList.append(True)
        else:
            labelList.append(False)
    return labelList

def label(labelList, inst):
    labels = {}
    for i, label in enumerate(labelList):
        if (label) :
            labelMarker = inst[i].find(":")
            label = inst[i][0:labelMarker].rstrip()
            labels[label] = 4*i
    return labels

def removeLabels(labelList, inst):
    pureInst = []
    for i, label in enumerate(labelList):
        if (label):
            labelMarker = inst[i].find(":")
            pureInst.append(inst[i][labelMarker+1:].lstrip())
        else:
            pureInst.append(inst[i])
    return pureInst

def get_instruction(instList):
    cleanInst = cleanUp(instList)
    labelList = containLabel(cleanInst)
    Labels = label(labelList, cleanInst)
    Instructions = removeLabels(labelList,cleanInst)
    return Instructions, Labels







##print(pureInst)
##print(labelList)

