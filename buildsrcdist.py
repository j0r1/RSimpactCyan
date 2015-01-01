#!/usr/bin/env python

import subprocess
import platform
import tempfile
import shutil
import sys
import os

def getRCommand():

    if platform.system() == "Windows": # Windows

        for n in os.listdir("c:\\Program Files\\R\\"):
            print n
            if n.startswith("R-3"):
                return "c:\\Program Files\\R\\" + n + "\\bin\\R.exe"
        
        raise Exception("Unable to find R executable")
       
    return "R"

def createSourcePackage(Rcmd = "R"):
    
    tmpDir = tempfile.mkdtemp()
    print "Created dir", tmpDir

    subprocess.check_call(["hg", "archive", tmpDir])

    curDir = os.getcwd()
    try:
        os.chdir(tmpDir)
        subprocess.check_call([ Rcmd, "CMD", "build", "pkg"])
        sourcePackage = [ n for n in os.listdir(".") if n.endswith(".tar.gz")][0]
    finally:
        os.chdir(curDir)

    return (tmpDir, sourcePackage)

if __name__ == "__main__":

    d,p = createSourcePackage(getRCommand())

    if os.path.exists(p):
        os.unlink(p)

    shutil.move(os.path.join(d,p), ".")
    shutil.rmtree(d)

