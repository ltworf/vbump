.PHONY: mypy
mypy:
	MYPYPATH=stubs mypy --config-file mypy.conf src/vbump


.PHONY: install
install:
	# Install command
	install -D src/vbump $${DESTDIR:-/}/usr/bin/vbump
	# install extras
	install -m644 -D CHANGELOG $${DESTDIR:-/}/usr/share/doc/vbump/CHANGELOG

.PHONY: dist
dist:
	cd ..; tar -czvvf vbump.tar.gz \
		vbump/CHANGELOG \
		vbump/COPYING \
		vbump/Makefile \
		vbump/mypy.conf \
		vbump/README.md \
		vbump/src/ \
		vbump/man/
		\
	mv ../vbump.tar.gz vbump_`head -1 CHANGELOG`.orig.tar.gz
	gpg --detach-sign -a *.orig.tar.gz

deb-pkg: dist
	mv vbump_`head -1 CHANGELOG`.orig.tar.gz* /tmp
	cd /tmp; tar -xf vbump*.orig.tar.gz
	cp -r debian /tmp/vbump/
	cd /tmp/vbump/; dpkg-buildpackage
	install -d deb-pkg
	mv /tmp/vbump_* deb-pkg
	$(RM) -r /tmp/vbump

.PHONY: clean
clean:
	$(RM) -r deb-pkg
