Installation and troubleshooting instructions
=============================================

Troubleshooting instructions are at the end of the page.

OS X
----

 1. Install the relevant binary package from http://research.edm.uhasselt.be/jori/simpact/programs :
    
    - Click on the directory with the version you want to use and download the
      file with the `.dmg` extension.
    - Download and open this file, and you'll see the SimpactCyan program with `.mpkg`
      extension that you'll need to install.
    - You may need to [use a right click (or control+click)](https://www.howtogeek.com/205393/gatekeeper-101-why-your-mac-only-allows-apple-approved-software-by-default/)
      and select 'Open' to be able to install it, as this is an unsigned dmg file. 

 2. In a new R session, run

        source("https://raw.githubusercontent.com/j0r1/RSimpactCyanBootstrap/master/initsimpact.R")

    to install the needed R packages.

 3. From then on, running `library("RSimpactCyan")` in an R session should work.

MS-Windows
----------

 1. Install the x86 version of the [Visual Studio 2015 redistributables](https://www.microsoft.com/en-us/download/details.aspx?id=48145).
    Click the link, click download, check `vc_redist.x86.exe`, press 'Next' and run the executable
    that is downloaded.

 2. Install the relevant binary package from http://research.edm.uhasselt.be/jori/simpact/programs,
    and install it in the default location: select the directory with the version you
    want to use, and download the `.exe` file.

 3. If you don't have Python 2.7 installed yet, [download and install it](https://www.python.org/downloads/).
    Make sure to install it in the `c:\python27` location.

 4. Make sure you have the [Rtools](https://cran.r-project.org/bin/windows/Rtools/) installed.

 5. In a new R session, run

        source("https://raw.githubusercontent.com/j0r1/RSimpactCyanBootstrap/master/initsimpact.R")

    to install the needed R packages.

 6. From then on, running `library("RSimpactCyan")` in an R session should work.

Ubuntu/Debian or Redhat Linux
-----------------------------

 1. Install the relevant binary package from http://research.edm.uhasselt.be/jori/simpact/programs : 
    select the directory with the version you'd like to use and download a
    `.deb` file or `.rpm` file that corresponds to your Linux version.

 2. In a new R session, run

        source("https://raw.githubusercontent.com/j0r1/RSimpactCyanBootstrap/master/initsimpact.R")

    to install the needed R packages.
 3. From then on, running `library("RSimpactCyan")` in an R session should work.

Other Linux versions
--------------------

 1. Make sure you have a C++ compiler, cmake and make installed.

 2. Use the [CompileSimpact.sh](https://raw.githubusercontent.com/j0r1/simpactcyan/master/tools/CompileSimpact.sh)
    script to download and compile the sources.

 3. At the end of the script, a line line

        source /some/path/to/activatesimpact.sh

    is shown. You need to start this before starting R.

 4. In a new R session, run

        source("https://raw.githubusercontent.com/j0r1/RSimpactCyanBootstrap/master/initsimpact.R")

    to install the needed R packages.

 5. From then on, running `library("RSimpactCyan")` in an R session should work, but note that each
    time before start R, you'll need to run the command from step 3.

Troubleshooting
---------------

The most important thing to figure out, is if the `rPithon` R package works. To check this, start a new
R session and run:

    library("rPithon")
    pithon.exec("a=1")

Typically, this is no problem on OS X or Linux as Python is preinstalled on those platforms, but
on MS-Windows you may see an error message. In that case you need to tell rPithon explicitly where
the Python executable is found, so in a new R session try

    library("rPithon")
    pithon.set.default.executable("c:/path/to/python.exe")
    pithon.exec("a=1")

which should resolve the issue. If this was the problem, you'll need to run the following commands
to be able to use RSimpactCyan:

    library("rPithon")
    pithon.set.default.executable("c:/path/to/python.exe")
    library("RSimpactCyan")

If rPithon does work but you still cannot use RSimpactCyan correctly, then the most likely problem
is that the binary package is either not installed, or cannot be found. So please check that
the binaries were indeed installed, and were installed in the default location.

One possible problem is that you may need to restart R entirely: the installation modifies some
environment variables that may not become active in an R session until a restart. In fact, the
safe choice here is to do a complete logout/login or just a reboot.

