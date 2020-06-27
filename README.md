This is [ydiff](https://github.com/ymattw/ydiff), distilled down to the very core.

It's been heavily modified and stripped down to a very specific feature subset:

- py3.6+
- assumes utf-8
- only read git unified diffs from stdin
- only side-by-side rendering

And, modified to have less colorful colorization.

Also, I'm definitely not smart enough to port it to more performant languages,
but I've made it quite fast.

I've also optimized it to build as a relatively clean Cython binary.

(TODO benchmarks)


## Usage

I use the following git aliases:
(TODO: figure out better arg passing, or honestly i should just turn these into shell funcs)

	[alias]
        d = "!gitdiff () { git diff $@ | ydiff | less; }; gitdiff $@"
        dc = "!gitdiffcached () { git diff --cached $@ | ydiff | less; }; gitdiffcached $@"
	    s = "!rev=${1:-HEAD}; git diff $rev~1 $rev | ydiff | less"

	[color]
		diff = never


## Build

I've only partially figured out static compilation on Linux x86_64.
I say partially since staticx does all the heavy lifting.
