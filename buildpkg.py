#!/usr/bin/env python

from __future__ import print_function
import os
import sys
import subprocess
import platform
import shutil
import string

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
                    startPos = l.find("R", idx)
                    endPos = len(l)-1
                    while l[endPos] not in string.letters:
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
    
    Rexe = "R"
    logFileName = "rlogfile"
    with open(logFileName, "wt") as logfile:
        subprocess.call([ Rexe, "CMD", "INSTALL", curDir, "--build", "-l", tmpLibDir ], stdout=logfile, stderr=logfile)

    pkgFile = getPackageFileName(logFileName)
    os.remove(logFileName)

    print("Package name is %s" % pkgFile)

    if platform.system() == "Windows": # Windows
        print("TODO")
    elif platform.system() == "Darwin": # OS X
        os.makedirs("bin/macosx/mavericks/contrib/3.1/")
        os.makedirs("bin/macosx/contrib/3.0/")
        shutil.copy(pkgFile, "bin/macosx/mavericks/contrib/3.1/")
        shutil.move(pkgFile, "bin/macosx/contrib/3.0/")
        shutil.copy(os.path.join(curDir,"DESCRIPTION"), "bin/macosx/mavericks/contrib/3.1/PACKAGES")
        shutil.copy(os.path.join(curDir,"DESCRIPTION"), "bin/macosx/contrib/3.0/PACKAGES")
    else:
        print("Unknown platform, not creating directory structure")

    shutil.rmtree(tmpLibDir)
    
if __name__ == "__main__":
    main()
