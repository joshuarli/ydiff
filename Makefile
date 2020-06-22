all: ydiff-bin

clean: rm -f ydiff.c ydiff-bin

ydiff.c: ydiff
	cython --embed -3 -D --fast-fail ydiff

ydiff-bin: ydiff.c
	# You might need to PKG_CONFIG_PATH="${PYENV_ROOT}/versions/3.6.7/lib/pkgconfig"
	# Or similar if you only have a python3 installed via pyenv.
	gcc -O3 -flto $$(pkg-config --cflags --libs python3) -o ydiff-bin ydiff.c
