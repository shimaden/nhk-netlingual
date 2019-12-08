SHELL = /bin/sh
BINDIR    = /usr/local/bin
CONF_DIR  = /usr/local/etc/nhk-netlingual
PROG_NAME = nhk-netlingual
EXE      = $(PROG_NAME).rb
CONF_FILES = program-list.conf

install: $(EXES) $(CONF_FILES)
	install -d -m 0755 -o root -g root $(CONF_DIR)
	install -m 0644 -o root -g root $(CONF_FILES) $(CONF_DIR)	
	install -m 0755 -o root -g root $(EXE) $(BINDIR)

clean:
	rm -f *~

mp3clean:
	rm -f *.mp3 *.mp3.part
