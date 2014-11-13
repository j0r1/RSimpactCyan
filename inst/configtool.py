import sys
import pprint
import copy
import subprocess
import json
import os

def getValidNames(strList):
    r = "['" + strList[0] + "'"
    for i in range(1,len(strList)):
        r += ", '" + strList[i] + "'"
    r += "]"
    return r

def getExpandedSettingsOptions(executable):

    proc = subprocess.Popen(executable, stdout=subprocess.PIPE)
    jsonData, unusedErr = proc.communicate()
    proc.wait()

    configOptions = json.loads(jsonData)
    configNames = configOptions["configNames"]
    distTypes = configOptions["distTypes"]

    # Change the config entries which have a 'distTypes' setting

    newConfig = copy.deepcopy(configNames)
    for n in configNames:
        params = configNames[n]['params']
        for i in range(len(params)):
            p = params[i]
            pName = p[0]
            pValue = p[1]
            if pValue == "distTypes":

                defaultDistName = 'fixed'
                defaultDistParams = None
                if len(p) == 3:
                    defaultDistOptions = p[2]
                    defaultDistName = defaultDistOptions[0]
                    defaultDistParams = defaultDistOptions[1]

                # Adjust the entry in 'newConfig'
                possibleNames = [ t for t in distTypes ]
                newConfig[n]['params'][i] = (pName + ".type", defaultDistName, possibleNames)

                #print "configNames[%s] = " % n
                #pprint.pprint(newConfig[n])
                #print

                for distName in distTypes:
                    distParams = distTypes[distName]['params']

                    if len(params) > 1:
                        newConfName = n + "_" + str(i) + "_" + distName
                    else:
                        newConfName = n + "_" + distName

                    newConfig[newConfName] = { 'depends': (n, pName + ".type", distName) }

                    if not defaultDistParams:
                        newConfig[newConfName]['params'] = [ (pName + "." + distName + "." + dp, dv) for dp,dv in distParams ]
                    else:
                        newConfig[newConfName]['params'] = [ (pName + "." + distName + "." + dp, dv) for dp,dv in defaultDistParams ]

                    newConfig[newConfName]['info'] = distTypes[distName]['info']

    return newConfig

def processConfigPart(cfg, userConfig, configNames, requiredKeys):

    params = cfg['params']
    deps = cfg['depends']

    # Check if we need to process dependencies
    if deps is not None:

        depObjName = deps[0]
        depObj = configNames[depObjName]
        depKey = deps[1]
        depVal = deps[2]
        
        #print "processConfigPart", depObjName
        #pprint.pprint(depObj)
        if not processConfigPart(depObj, userConfig, configNames, requiredKeys):
            # Parent dependency not fulfilled, so this one isn't either
            return False
        #print "done: processConfigPart", depObjName

        if not depKey in userConfig:
            pprint.pprint(userConfig)
            raise Exception("Key %s was not set" % depKey)
        
        if userConfig[depKey] != depVal:
            return False # Dependency not fulfilled

        for k in params:
            if len(k) == 3:
                requiredKeys[k[0]] = k[2]
            else:
                requiredKeys[k[0]] = None

    for p in params:

        key = p[0]
        val = p[1]

        if len(p) == 3:

            requiredKeys[key] = p[2]
        else:
            requiredKeys[key] = None

        # See if we should check defaults
        if not key in userConfig: 
            #if val is None:
            #    raise Exception("Key %s is not set" % key)

            userConfig[key] = val
        
    return True

def createConfigLines(executable, inputConfig, checkNone = True, ignoreKeys = [ ]):
    userConfig = copy.deepcopy(inputConfig)
    configNames = getExpandedSettingsOptions(executable)

    requiredKeys = { }

    for n in configNames:
        cfg = configNames[n]
        #print "createConfigLines", n
        #print cfg
        processConfigPart(cfg, userConfig, configNames, requiredKeys)

    for k in userConfig:
        if not k in requiredKeys:
            raise Exception("Encountered unknown key %s" % k)

        val = userConfig[k]

        possibleValues = requiredKeys[k]
        if possibleValues is not None:
            if not val in possibleValues:
                raise Exception("Value '%s' for key %s is not allowed, should be one of %s" % (val, k, possibleValues))

        if checkNone:
            if val is None:
                raise Exception("Key %s is not set" % k)

    # Display the final config file

    lines = [ ]
    unusedlines = [ ]
    # In principle this should contain the same info as userConfig at the end,
    # but we'll introduce some ordering here so we can feed it back to R in a better
    # way
    resultingConfig = [ ] 

    names = [ key for key in configNames ]
    names.sort()
    for key in names:
        deps = configNames[key]["depends"]
        params = configNames[key]["params"]
        info = configNames[key]["info"]

        if info:
            info = "\n".join(info)

        usedparams = [ ]
        unusedparams = [ ]
        for p in params:
            k = p[0]
            if k in requiredKeys:
                
                v = userConfig[k]
                ns = 60-len(k)
                k += " "*ns

                if len(p) == 3: # Limited number of possibilities
                    usedparams.append("# Valid values are: " + getValidNames(p[2]))

                if v is None:
                    usedparams.append("%s = " % k)
                elif type(v) == float:
                    usedparams.append("%s = %.15g" % (k, v))
                elif type(v) == int:
                    usedparams.append("%s = %d" % (k, v))
                else:
                    usedparams.append("%s = %s" % (k, str(v)))

                idx = len(resultingConfig)+1

                if v is None:
                    resultingConfig.append((idx, p[0], ""))
                else:
                    resultingConfig.append((idx, p[0], v))

            else:
                unusedparams.append("# " + p[0])

        if usedparams:
            if deps:
                lines += [ "# The following depends on %s = %s" % (deps[1], deps[2]) ]

            if info:
                lines += [ "# " + l for l in info.splitlines() ]

            lines += usedparams
            lines += [ "" ]

        if unusedparams:
            if deps:
                unusedlines += [ "# The following depends on %s = %s" % (deps[1], deps[2]) ]

            unusedlines += unusedparams
            unusedlines += [ "#" ]

    introlines = [ "# Note: the configuration file format is very simple, it is",
                   "# just a set of \"key = value\" lines. Lines that start with a '#'",
                   "# sign are treated as comments and are ignored. No calculations",
                   "# can be done in the file, so instead of writing 1.0/2.0, you'd ",
                   "# need to write 0.5 for example.",
                   ""
                 ]
    return (userConfig, introlines + unusedlines + [ "" ] + lines, resultingConfig)

def checkKnownKeys(executable, keyList):

    configNames = getExpandedSettingsOptions(executable)

    allKnownKeys = [ ]
    for n in configNames:
        paramList = configNames[n]["params"]
        paramKeys = [ ]
        for p in paramList:
            paramKeys.append(p[0])

        allKnownKeys += paramKeys

    for k in keyList:
        if not k in allKnownKeys:
            raise Exception("Encountered unknown key '%s'" % k)

def main():

    executable = [ sys.argv[1], "--showconfigoptions"]

    # Read the input

    userConfig = { }
    line = sys.stdin.readline()
    while line:

        line = line.strip()
        if line:
            parts = [ p.strip() for p in line.split('=') ]
            
            key, value = parts[0], parts[1]
            userConfig[key] = value

        line = sys.stdin.readline()

    # In principle, the 'resultingConfigNotNeeded' should contain the same things
    # as finalConfig, but some ordering was introduced
    (finalConfig, lines, resultingConfigNotNeeded) = createConfigLines(executable, userConfig, False)

    lines.append('')
    sys.stdout.write('\n'.join(lines))


if __name__ == "__main__":
    main()


