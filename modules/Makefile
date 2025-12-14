build:
	mkdir build -p
	gcc src/shared-memory-manager.c -o build/shmm
	g++ src/polybar-widget.cpp `fltk-config --cxxflags --ldflags --use-images` -lfontconfig -o build/polybar-widget
clear:
	rm -rf build

install:
	cp build/shmm ~/.local/sbin/
	cp build/polybar-widget ~/.local/sbin/
