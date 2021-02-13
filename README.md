<div align="center">
  <img width="256" src="docs/logo.png" alt="bic">
</div>

# bic

![Build Status](https://img.shields.io/github/workflow/status/Pinjasaur/bic/Build)

Opinionated minimal static site (blog) generator. Implemented in a single Bash
script.

## Getting Started

Check out the [docs] or [bic-example] repository.

## Local Development

Build (local develop):

```bash
docker build . -t bic:local
```

Run (local develop) with [bic-example]:

```bash
docker run --rm -it -v $PWD/../bic-example:/src -v $PWD:/app --entrypoint bash bic:local
```

Run (just build) with [bic-example]:

```bash
docker run --rm -v $PWD/../bic-example:/src bic:local
```

Local server (ran in [bic-example]):

```bash
browser-sync --watch --no-notify --extensions html build
```

## License

[MIT].

[docs]: https://bic.sh/
[bic-example]: https://github.com/Pinjasaur/bic-example
[MIT]: https://pinjasaur.mit-license.org/2021
