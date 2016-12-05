#!/usr/bin/env python

import subprocess
import platform
import tempfile
import tarfile
import shutil
import sys
import os

def getRCommand():

    if platform.system() == "Windows": # Windows

        for n in os.listdir("c:\\Program Files\\R\\"):
            print n
            if n.startswith("R-3"):
                fn = "c:\\Program Files\\R\\" + n + "\\bin\\R.exe"
                if os.path.exists(fn):
                    return fn
        
        raise Exception("Unable to find R executable")
       
    return "R"

def createSourcePackage(Rcmd = "R"):
    
    tmpDir = tempfile.mkdtemp()
    print "Created dir", tmpDir

    curDir = os.getcwd()
    print "Current dir", curDir

    tarBall = subprocess.check_output([ "git", "archive", "--format", "tar", "--prefix=archive/", "HEAD"])

    try:
        os.chdir(tmpDir)
        with open("archive.tar", "wb") as f:
            f.write(tarBall)

        tar = tarfile.open("archive.tar", "r")
        tar.extractall()
        tar.close()

        #subprocess.check_call([ "tar", "xf", "archive.tar" ])
        subprocess.check_call([ Rcmd, "CMD", "build", os.path.join("archive","pkg")])
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

