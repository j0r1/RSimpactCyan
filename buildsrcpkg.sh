#!/bin/bash

VERSION=`cat DESCRIPTION|grep "Version:" | cut -f 2 -d " "`
LIBNAME=RSimpactCyan

CURDIR=`pwd`
TMPDIR=`tempfile`
rm -r $TMPDIR
if ! mkdir $TMPDIR ; then
	echo "Couldn't create temporary directory"
	exit -1
fi

if ! hg archive $TMPDIR/${LIBNAME}-${VERSION} ; then
	echo "Couldn't export repository"
	exit -1
fi

cd $TMPDIR

rm -f `find ${LIBNAME}-${VERSION} -name ".hg*"`
rm ${LIBNAME}-${VERSION}/buildsrcpkg.sh
rm ${LIBNAME}-${VERSION}/buildpkg.py
	
if ! tar cfz ${LIBNAME}_${VERSION}.tar.gz ${LIBNAME}-${VERSION}/ ; then
	echo "Couldn't create archive"
	exit -1
fi

TMPDIRNAME=`basename $TMPDIR`
mv $TMPDIR $CURDIR/
cd $CURDIR/$TMPDIRNAME
mkdir -p src/contrib/
cp ${LIBNAME}-${VERSION}/DESCRIPTION src/contrib/PACKAGES
mv ${LIBNAME}_${VERSION}.tar.gz src/contrib/
rm -r ${LIBNAME}-${VERSION}
