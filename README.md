# bic

Minimal static site (blog) generator, written in bash.

## Getting Started

```bash
mkdir {static,pages,posts,drafts}
touch {index,entry}.html
```

The _bare minimum_ is `pages/` OR `posts/` AND `index.html` + `entry.html`.

## Docker

Build (local develop):

```bash
$ docker build . -t bic:local
```

Run (local develop):

```bash
$ docker run --rm -it -v $PWD/../bic-example:/src -v $PWD:/app --entrypoint bash bic:local
```

Local server:

```bash
$ browser-sync --watch --no-notify --extensions html build
```
