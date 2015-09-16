import sys
import os

try:
    sys.dont_write_bytecode = True
except:
    pass

paths = [ ]
paths += [ "C:\\Program Files (x86)\\SimpactCyan\\python\\", "C:\\Program Files\\SimpactCyan\\python\\" ]
paths += [ "/usr/share/simpact-cyan/python/", "/usr/local/share/simpact-cyan/python/" ]
paths += [ "/Applications/SimpactCyan.app/Contents/python/" ]

for p in paths:
    if os.path.exists(p) and os.path.isdir(p):
        sys.path.append(p)

simpactPythonInstance = None
try:
    import pysimpactcyan
    simpactPythonInstance = pysimpactcyan.PySimpactCyan()
except:
    pass

if not simpactPythonInstance:
    print("Warning: python module from the simpact cyan binaries could not be found, package will not be useable")

def isSimpactCyanAvailable():
    if simpactPythonInstance:
        return True
    return False
