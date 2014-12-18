import sys
import os
import subprocess
import tempfile
import shutil
import configtool
import random
import time
import pprint
import copy
import platform

class SimpactPython(object):
    def __init__(self):
        self.execPrefix = "simpact-cyan"
        self.dataDirectory = self.findSimpactDataDirectory()
        self.execDir = self.findSimpactDirectory()

    def setSimpactDirectory(self, dirName):
        self.execDir = dirName

    def setSimpactDataDirectory(self, dirName):
        self.dataDirectory = dirName

    def findSimpactDataDirectory(self):
        paths = [ ]
        if platform.system() == "Windows":
            paths += [ "C:\\Program Files (x86)\\SimpactCyan\\data", "C:\\Program Files\\SimpactCyan\\data" ]
        else:
            paths += [ "/usr/share/simpact-cyan", "/usr/local/share/simpact-cyan" ]
            paths += [ "/Applications/SimpactCyan.app/Contents/data" ]

        for p in paths:
            f = os.path.join(p, "sa_2003.csv")
            if os.path.exists(f):
                print "Setting data directory to", p
                return p

        print "Warning: can't seem to find a way to run the simpact data directory"
        return None

    def findSimpactDirectory(self):
        with open(os.devnull, "w") as DEVNULL:
            paths = [ ]
            if platform.system() == "Windows":
                paths += [ "C:\\Program Files (x86)\\SimpactCyan", "C:\\Program Files\\SimpactCyan" ]

            exe = "simpact-cyan-opt" # This should always exist

            # First see if we can run the executable without a full path
            try:
                subprocess.call([ exe ], stderr=DEVNULL, stdout=DEVNULL)
                return None
            except:
                pass

            # Then try some predefined paths
            for p in paths:
                try:
                    subprocess.call([ os.path.join(p,exe) ], stderr=DEVNULL, stdout=DEVNULL)
                    print "Simpact executables found in %s" % p
                    return p
                except:
                    pass

        print "Warning: can't seem to find a way to run the simpact executables"
        return None

    def setSimulationPrefix(self, prefix):

        if not prefix:
            raise Exception("No valid simulation prefix specified")

        with open(os.devnull, "w") as DEVNULL:
            try:
                p = self.getExecPath(testPrefix = prefix)
                subprocess.call( [ p ], stderr=DEVNULL, stdout=DEVNULL)
                self.execPrefix = prefix
            except Exception as e:
                raise Exception("Unable to use specified prefix '%s' (can't run '%s')" % (prefix, p))

    def getExecPath(self, opt = True, release = True, testPrefix = None):

        fullPath = testPrefix if testPrefix else self.execPrefix
        fullPath += "-"
        fullPath += "opt" if opt else "basic"

        if not release:
            fullPath += "-debug"

        if self.execDir is not None:
            fullPath = os.path.join(self.execDir, fullPath)
        return fullPath

    def runDirect(self, configFile, parallel = False, opt = True, release = True, outputFile = None, seed = -1, destDir = None):

        #print "configFile", configFile
        #print "parallel", parallel
        #print "opt", opt
        #print "release", release
        #print "outputFile", outputFile
        #print "seed", seed
        #print "destDir", destDir
        
        fullPath = self.getExecPath(opt, release)
        parallelStr = "1" if parallel else "0"

        if destDir is None:
            destDir = os.path.abspath(os.path.dirname(configFile))
    
        closeOutput = False
        origDir = os.getcwd()
        try:
            os.chdir(destDir)

            if outputFile is not None:
                if os.path.exists(outputFile):
                    raise Exception("Want to write to output file '%s', but this already exists" % outputFile)

                f = open(outputFile, "wt")
                closeOutput = True
            else:
                f = sys.stdout

            newEnv = copy.deepcopy(os.environ)
            if seed >= 0:
                newEnv["MNRM_DEBUG_SEED"] = str(seed)
            
            print "Results will be stored in directory '%s'" % os.getcwd()
            print "Running simpact executable..."
            proc = subprocess.Popen([fullPath, configFile, parallelStr], stdout=f, stderr=f, cwd=os.getcwd(), env=newEnv)
            proc.wait() # Wait for the process to finish
            print "Done."
            print

            if proc.returncode != 0:
                raise Exception("Program exited with an error code (%d)" % proc.returncode)
            
        finally:
            if closeOutput:
                f.close()

            if closeOutput: # If not in a file, it was already on screen
                # Also show the output on screen
                with open(outputFile, "rt") as f:
                    line = f.readline()
                    while line:
                        sys.stdout.write(line)
                        line = f.readline()
                    f.close()

            os.chdir(origDir)

    def createConfigLines(self, inputConfig, checkNone = True, ignoreKeys = []):
        executable = [ self.getExecPath(), "--showconfigoptions" ]
        return configtool.createConfigLines(executable, inputConfig, checkNone, ignoreKeys)

    def checkKnownKeys(self, keyList):
        executable = [ self.getExecPath(), "--showconfigoptions" ]
        return configtool.checkKnownKeys(executable, keyList)

    def getConfiguration(self, config, show):
        # Make sure config is a dict
        if not config:
            config = { }

        ignoreKeys = [ "population.agedistfile", "logsystem.filename.events", "logsystem.filename.persons", "logsystem.filename.relations" ]

        finalConfig, lines, sortedConfig = self.createConfigLines(config, False, ignoreKeys)
        lines.append('')

        if show:
            sys.stdout.write('\n'.join(lines))

        return sortedConfig

    def getID(self):
        chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        rndStr = ""
        for i in range(8):
            pos = int(random.random()*len(chars)) % len(chars)
            rndStr += chars[pos]

        t = time.gmtime()
        timeStr = "%d-%02d-%02d-%02d-%02d-%02d" % (t.tm_year, t.tm_mon, t.tm_mday, t.tm_hour, t.tm_min, t.tm_sec)

        pidStr = str(os.getpid())

        return timeStr + "_" + pidStr + "_" + rndStr

    def run(self, config, destDir, agedist, parallel = False, opt = True, release = True, seed = -1, interventionConfig = None, dryRun = False):

        if not destDir:
            raise Exception("A destination directory must be specified")

        # Make sure config is a dict
        if not config:
            config = { }

        distAges = agedist["Age"]
        distMalePct = agedist["Percent.Male"]
        distFemalePct = agedist["Percent.Female"]

        if len(distAges) != len(distMalePct) or len(distAges) != len(distFemalePct):
            raise Exception("Not all columns of the 'agedist' variable seem to have the same length")

        idStr = self.getID()

        # The config files will be overridden to make sure we write in the specified
        # destination directory
        eventLog = "simpact-%s-eventlog.csv" % idStr
        personLog = "simpact-%s-personlog.csv" % idStr
        relationLog = "simpact-%s-relationlog.csv" % idStr
        treatmentLog = "simpact-%s-treatmentlog.csv" % idStr
        config["logsystem.filename.events"] = eventLog
        config["logsystem.filename.persons"] = personLog
        config["logsystem.filename.relations"] = relationLog
        config["logsystem.filename.treatments"] = treatmentLog

        #distFile = os.path.abspath(os.path.join(destDir, "simpact-%s-agedist.csv" % idStr))
        distFile = "simpact-%s-agedist.csv" % idStr
        config["population.agedistfile"] = distFile

        # Intervention event stuff

        intTimes = None
        intBaseFile = None
        ivIDs = []
        if interventionConfig:
            # Lets make sure we order the intervention times

            intTimes = [ ]
            if type(interventionConfig) == dict:

                for iv in interventionConfig:
                    t = float(interventionConfig[iv]["time"])
                    del interventionConfig[iv]["time"]
                    intTimes.append( (t, interventionConfig[iv]) )

            else: # assume it's a list
                for iv in interventionConfig:
                    t = float(iv["time"])
                    del iv["time"]
                    intTimes.append( (t, iv) )

            intTimes.sort() # Make sure it's sorted on time, interpreted as a real number

        if intTimes:

            config["intervention.enabled"] = "yes"            

            isFirstTime = True
            ivTimeString = ""
            ivIDString = ""
            count = 1
            for (t,iv) in intTimes:
                if not isFirstTime:
                    ivTimeString += ","
                    ivIDString += ","
                
                ivTimeString += str(t)
                ivIDString += str(count)
                ivIDs.append(str(count))

                isFirstTime = False
                count += 1
                
            config["intervention.times"] = ivTimeString
            config["intervention.fileids"] = ivIDString

            intBaseFile = "simpact-%s-interventionconfig_%%.txt" % idStr
            config["intervention.baseconfigname"] = intBaseFile

        if os.path.exists(destDir):
            # Check that we're actually dealing with a directory
            if not os.path.isdir(destDir):
                raise Exception("Specified destination directory '%s' exists but does not seem to be a directory" % destDir)

        else:
            # Create the directory
            print "Specified destination directory '%s' does not exist, creating it" % destDir
            os.makedirs(destDir)

        # Here, the actual configuration file lines are created
        finalConfig, lines, notNeeded = self.createConfigLines(config, True)

        # Check if we need to replace the data directory
        for i in range(len(lines)):
            l = lines[i]
            if "%DATADIR%" in l:
                if not self.dataDirectory:
                    raise Exception("Special identifier %DATADIR% is used in the following line, but no data directory has been set: '%s'" % l)
                lines[i] = self.replaceDataDir(l)

        # Check some paths
        configFile = os.path.abspath(os.path.join(destDir, "simpact-%s-config.txt" % idStr))
        if os.path.exists(configFile):
            raise Exception("Want to write to configuration file '%s', but this already exists" % configFile)

        outputFile = os.path.abspath(os.path.join(destDir, "simpact-%s-output.txt" % idStr))
        if os.path.exists(outputFile):
            raise Exception("Want to write to output file '%s', but this already exists" % outputFile)

        fullDistFile = os.path.abspath(os.path.join(destDir, distFile))
        if os.path.exists(fullDistFile):
            raise Exception("Want to write to age distribution file '%s', but this already exists" % fullDistFile)

        # Write the config file
        with open(configFile, "wt") as f:
            for l in lines:
                f.write(l + "\n")
            f.close()

        # Write the age distribution file
        with open(fullDistFile, "wt") as f:
            f.write("Age,Percent Male,Percent Female\n")
            for i in range(len(distAges)):
                f.write("%g,%g,%g\n" % (distAges[i], distMalePct[i], distFemalePct[i]))
            f.close()

        # write intervention config files
        if intTimes:
            for tIdx in range(len(intTimes)):

                t = intTimes[tIdx][0]
                iv = intTimes[tIdx][1]

                # With the current approach, the best we can do is to check for keys that
                # are never used in a config file
                self.checkKnownKeys([ name for name in iv ])

                fileName = intBaseFile.replace("%", ivIDs[tIdx])
                fileName = os.path.join(destDir, fileName)
                with open(fileName, "w") as f:
                    for k in iv:
                        f.write("%s = %s\n" % (k,iv[k]))
                    f.close()

        # Set environment variables (if necessary) and start executable

        if not dryRun:
            print "Using identifier '%s'" % idStr
            self.runDirect(configFile, parallel, opt, release, outputFile, seed, destDir)

        results = { }
        results["logevents"] = os.path.join(destDir, eventLog)
        results["logrelations"] = os.path.join(destDir, relationLog)
        results["logpersons"] = os.path.join(destDir, personLog)
        results["logtreatments"] = os.path.join(destDir, treatmentLog) 
        results["configfile"] = os.path.join(destDir, configFile)
        results["outputfile"] = os.path.join(destDir, outputFile)
        results["agedistfile"] = os.path.join(destDir, distFile)
        results["id"] = "simpact-%s-" % idStr

        return results

    def replaceDataDir(self, l):
        # TODO: adjust this so it works equally well in windows and linux
        #return l.replace("%DATADIR%", str(self.dataDirectory))

        dataDirId = "%DATADIR%"

        maxRepl = 64 # Make sure we don't get stuck
        for r in range(maxRepl):
            idx = l.find(dataDirId)
            if idx < 0: # Nothing could be found
                return l

            offset = 0
            p = idx+len(dataDirId)
            if p < len(l) and l[p] in [ '\\', '/' ]:
                offset = 1

            l = l[:idx] + os.path.join(self.dataDirectory, l[idx+len(dataDirId)+offset:])

        return l
