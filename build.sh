#!/bin/bash

VERSION=0.10.17
clean=0
srcdeb=""

set -e
if [ $# -eq 0 ] ; then
    #If no argument is given, get the latest version from the download page
    VERSION=$(wget http://nodejs.org/download/ -qO- | grep "Current version" | sed 's/.*<b>v\([^<]*\)<\/b>.*/\1/')
    echo "Building latest Node.js version (v${VERSION})"
else #Use the arguments from the command line
    while [ ! -z "$1" ]; do
        [[ "$1" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] && VERSION=$1
        [[ "$1" =~ \.patch$ ]] && patchfile=$1
        [ "$1" = "clean" ] && clean=1
        [ "$1" = "source" ] && srcdeb="-S"
        shift
    done
fi

node_url=http://nodejs.org/dist/v${VERSION}/node-v${VERSION}.tar.gz
node_tar=node-v${VERSION}.tar.gz
node_dir=nodejs-${VERSION}

if [ "$clean" -eq 1 ]; then
	echo Cleaning v${VERSION}...
	rm -rf "$node_dir"
	rm -rvf nodejs_${VERSION}*.{dsc,changes,deb,tar.gz}
	exit 0
fi

if [ ! -z "$patchfile" ] && [ ! -f "$patchfile" ]; then
	echo "Patch file not found: $patchfile"
	exit 1
fi

if [ ! -f "$node_tar" ]; then
	wget "$node_url" -nc -c -O "$node_tar"
fi

if [ ! -d "$node_dir/debian" ]; then
	echo "Extracting $node_tar ..."
	mkdir -p "$node_dir"
	tar zxf "$node_tar" --strip-components=1 -C "$node_dir"
	
	echo "Creating $node_dir/debian ..."
	cp -a deb "$node_dir/debian"
	sed -e "s/\${VERSION}/${VERSION}/" deb/changelog > "$node_dir/debian/changelog"

	if [ ! -z "$patchfile" ]; then
		echo "Patching ..."
		(cd "$node_dir" && patch -p1 < "../$patchfile")
	fi
fi

cd "$node_dir"
dpkg-buildpackage $srcdeb -uc -j6

cd -

[ "$srcdeb" = "" ]   && ls -l nodejs_*deb
[ "$srcdeb" = "-S" ] && ls -l nodejs_*

