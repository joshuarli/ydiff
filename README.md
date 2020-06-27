This is [ydiff](https://github.com/ymattw/ydiff), distilled down to the very core.

It's been heavily modified and stripped down to a very specific feature subset:

- py3.6+
- assumes utf-8
- only read git unified diffs from stdin
- only side-by-side rendering

And, modified to be visually less noisy. Here's what it looks like:

TODO

## Performance

I'm definitely not smart enough to port it to more performant languages,
but I've made it quite fast:

```
$ git log --patch | pv > /tmp/sentry-git-log
... 17.4MiB/s ...
-rw-r--r-- 1 josh josh 573M Jun 27 00:00 /tmp/sentry-git-log

$ ./ymattw-ydiff.py --wrap --side-by-side --color=always --pager=cat \
    < /tmp/sentry-git-log | pv >/dev/null

... 761KiB/s ...

$ ./ydiff < /tmp/sentry-git-log | pv >/dev/null

... 1.37MiB/s ...
```

I've also optimized it to build as a relatively clean Cython binary,
which runs a bit faster but more importantly is faster to start up:

```
$ ./ydiff-bin < /tmp/sentry-git-log | pv >/dev/null
... 1.60MiB/s ...

$ hyperfine --warmup 3 "./ydiff < tests/sentry/1/in.diff >/dev/null"
Benchmark #1: ./ydiff < tests/sentry/1/in.diff >/dev/null
  Time (mean ± σ):     115.3 ms ±   2.3 ms    [User: 53.1 ms, System: 43.4 ms]
  Range (min … max):   112.5 ms … 123.7 ms    24 runs

$ hyperfine --warmup 3 "./ydiff-bin < tests/sentry/1/in.diff >/dev/null"
Benchmark #1: ./ydiff-bin < tests/sentry/1/in.diff >/dev/null
  Time (mean ± σ):      35.8 ms ±   1.9 ms    [User: 26.3 ms, System: 7.8 ms]
  Range (min … max):    32.8 ms …  40.2 ms    74 runs
```


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
