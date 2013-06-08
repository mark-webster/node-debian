preinstall:
	apt-get install devscripts debhelper dpkg-dev make g++ cdbs dh-buildinfo openssl pkg-config build-essential curl zlib1g-dev wget

v6:
	./build.sh clean
	./build.sh 0.6.19
v8:
	./build.sh clean
	./build.sh 0.8.16


clean:
	./build.sh clean
