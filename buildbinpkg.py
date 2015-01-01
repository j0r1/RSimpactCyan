#!/usr/bin/env python

import os
import sys
import subprocess
import shutil
import buildsrcdist
import platform

def getPackageFileName(logFileName):
    with open(logFileName, "rt") as f:
        l = f.readline()
        while l:
            l = l.strip()
            print(l)
            if l.startswith("packaged installation of"):
                s = " as "
                idx = l.find(s)
                if idx >= 0:
                    idx += 4
		    while not l[idx].isalpha():
			    idx += 1

		    startPos = idx
                    endPos = len(l)-1
		    while not l[endPos].isalpha():
                        endPos -= 1

                    return l[startPos:endPos+1]

            l = f.readline()

def main():
    instDir = sys.argv[1]

    os.mkdir(instDir)
    curDir = os.getcwd()
    os.chdir(instDir)
    instDir = os.getcwd()
    tmpLibDir = os.path.join(instDir, "tmpLibDir")
    os.mkdir(tmpLibDir)
    
    Rexe = buildsrcdist.getRCommand();
    tmpSrcDir, srcPackName = buildsrcdist.createSourcePackage(Rexe)

    logFileName = "rlogfile"

    try:
        with open(logFileName, "wt") as logfile:
            subprocess.call([ Rexe, "CMD", "INSTALL", os.path.join(tmpSrcDir, srcPackName), "--build", "-l", tmpLibDir ], stdout=logfile, stderr=logfile)
    finally:
        shutil.rmtree(tmpSrcDir)

    pkgFile = getPackageFileName(logFileName)
    os.remove(logFileName)

    print("Package name is %s" % pkgFile)

    if platform.system() == "Windows": # Windows
        os.makedirs("bin/windows/contrib/3.1/")
        shutil.move(pkgFile, "bin/windows/contrib/3.1/")
    elif platform.system() == "Darwin": # OS X
        os.makedirs("bin/macosx/mavericks/contrib/3.1/")
        os.makedirs("bin/macosx/contrib/3.0/")
        shutil.copy(pkgFile, "bin/macosx/mavericks/contrib/3.1/")
        shutil.move(pkgFile, "bin/macosx/contrib/3.0/")
    else:
        print("Unknown platform, not creating directory structure")

    shutil.rmtree(tmpLibDir)
    
if __name__ == "__main__":
    main()
