.PHONY: all
all: clean
	make ydiff-bin

.PHONY: clean
clean:
	rm -f ydiff.c ydiff-bin ydiff-bin-static

ydiff.c: ydiff
	cython --embed -3 -D --fast-fail ydiff

ydiff-bin: ydiff.c
	# You might need to PKG_CONFIG_PATH="${PYENV_ROOT}/versions/3.6.7/lib/pkgconfig"
	# Or similar if you only have a python3 installed via pyenv.
	gcc -O3 -flto $$(pkg-config --cflags --libs python3) -o ydiff-bin ydiff.c

.PHONY: static
static: ydiff-bin-static
ydiff-bin-static: ydiff-bin
	# Unfortunately, decompressing ~9M to ~3M is a bit slow.
	# I'd also ideally like to figure out how to statically compile with just gcc.
	# gcc -static + pkg-config --static doesn't exactly work...
	# and if you ldd what the resulting binary is linked to, and dpkg --search the .a files,
	# there's more -l you need to pass.
	# Even after you get all that correct, the linker spews errors.
	# python-config (a pkg-config wrapper) doesn't work either.
	staticx --no-compress ydiff-bin $@
	strip -s $@
