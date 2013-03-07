#!/bin/sh

VERSION=0.8.22
node_url=http://nodejs.org/dist/v${VERSION}/node-v${VERSION}.tar.gz
node_tar=node-v${VERSION}.tar.gz
node_dir=nodejs-${VERSION}
patchfile=nodejs.patch

set -e

if [ "$1" = "clean" ]; then
	echo Cleaning ...
	rm -rf "$node_dir"
	rm -rvf nodejs_${VERSION}*.{dsc,changes,deb,tar.gz}
fi

if [ ! -f "$node_tar" ]; then
	wget "$node_url" -nc -c -O "$node_tar"
fi

if [ ! -d "$node_dir/src" ]; then
	echo "Extracting $node_tar ..."
	mkdir -p "$node_dir"
	tar zxf "$node_tar" --strip-components=1 -C "$node_dir"
	echo "Creating $node_dir/debian ..."
	cp -a deb "$node_dir/debian"
	sed -e "s/\${VERSION}/${VERSION}/" deb/changelog > "$node_dir/debian/changelog"

	if [ -z "$patchfile" ] && [ -f "$patchfile" ]; then
		echo "Patching ..."
		(cd "$node_dir" && patch -p1 < "../$patchfile")
	fi
fi

cd "$node_dir"
dpkg-buildpackage

cd -
ls -l nodejs_*deb
