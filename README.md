# sexp2xml
## the better _SXML_

[![Support Ukraine!](https://img.shields.io/badge/Support-Ukraine-005BBB?labelColor=FFD500)](https://novaukraine.org/)

**sexp2xml** is a Common Lisp library to convert an expression in the (much
superior) _S-expression_ format to the horrible and dreadful, awful, and
criminal XML format.

## Why

Writing XML (or its many, **many** variants) is painful, and I just was bored
and needed to do SOMETHING instead of reading Usenet while the radio was playing
for hours.

This library also works with the many variants of XML, mostly, since most of them
are exactly the same. Some popular ones include:

* HTML
* RSS
* SVG

It is really more of a shitty SGML construction library for Common Lisp, but there
are more people that know what XML is than what know what SGML is :).

## Installation

sexp2xml is not on Quicklisp yet, so I guess you'll need to install manually.

Clone [this repo](https://github.com/cajald/sexp2xml) and `cd` into it, then do:

```sh
$ mkdir -p ~/quicklisp/local-projects/sexp2xml/
$ cp * ~/quicklisp/local-projects/sexp2xml/
```

And now you should be able to `ql:quickload` library. If you do not have Quicklisp,
install the library to `~/common-lisp` and load it with `asdf:load-system`.

As before, clone the library and `cd` into it, and then run:

```sh
$ mkdir -p ~/common-lisp/sexp2xml
$ cp * ~/common-lisp/sexp2xml/
```

To load it, do:

```lisp
CL-USER> (ql:quickload :sexp2xml)      ; quicklisp
CL-USER> (asdf:load-system "sexp2xml") ; asdf
```

## License

CC0. See the [LICENSE](./LICENSE) file for more information. Warranty:

> Affirmer offers the Work as-is and makes no representations or warranties of
> any kind concerning the Work, express, implied, statutory or otherwise, including
> without limitation warranties of title, merchantability, fitness for a particular
> purpose, non infringement, or the absence of latent or other defects, accuracy, or
> the present or absence of errors, whether or not discoverable, all to the greatest
> extent permissible under applicable law.

Originally written by [**Mario Rosell `<mario AT mariorosell DOT es>`**](mailto:mario@mariorosell.es).

