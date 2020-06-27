.PHONY: all
all: clean
	make ydiff-bin

.PHONY: clean
clean:
	rm -f ydiff.c ydiff-bin ydiff-bin-static

ydiff.c: ydiff
	cython --embed -3 -D --fast-fail ydiff

.PHONY: fast
fast: clean
	make ydiff.c

ydiff-bin: ydiff.c
	# Some other incantations that might work (or similar):
	# gcc -O3 -flto $^ $$(python3-config --cflags --ldflags) -o $@
	# gcc -O3 -flto $^ -I/usr/include/python3.8 -lpython3.8 -o $@
	gcc -O3 -flto $^ $$(pkg-config --cflags --libs python3) -o $@
