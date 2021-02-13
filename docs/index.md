<div align="center">
  <img width="256" src="docs/logo.png" alt="bic">
</div>

# bic docs

`bic` is an opinionated and minimal static site generator&mdash;with a focus on
blogs.

{% raw %}
It uses [Pandoc] to convert plain Markdown files into HTML. They get templated
{{[Mustache]}}-style with [Mo]. [Hashids] is used to generate IDs.
{% endraw %}

## Basics

You get the (opinionated) basics of a static site/blog (read: opinionated):

- Pages e.g., `pages/about.md` &rarr; `/about.html`
- Posts e.g., `posts/999-first-post.md` &rarr; `/first-post.html`
- Drafts e.g., `drafts/998-untitled.md` &rarr; `/drafts/untitled.html`
- Static content e.g., `static/*` &rarr; `/*`
- robots.txt
- sitemap.xml
- RSS feed

For reproducible builds, I would recommend using `bic` with Docker: `ghcr.io/pinjasaur/bic`

Essentially, mount your source directory to `/src`

```bash
docker run --rm -v "$PWD":/src ghcr.io/pinjasaur/bic:latest
```

to spit out a `build` directory with your generated site.

## Opinionated

`bic` is strict where necessary to keep it opinionated with a lean scope.

- Pages exist in `pages/*.md`. Not nested.
- Posts & drafts exist within `posts/*.md` and `drafts/*.md`, respectively.
    - _Ordering_ is determined by a leading digit sequence e.g., `999-post.md`
    for the first post, `998-tacocat.md` for the second, et cetera. I would
    recommend 3 or 4 digits for the Future Proof&trade;.
    - This lets the file `mtime` be used for the author's discretion. However,
    Git doesn't record `mtime`, so I would treat it as the "last modified" date.
    - The title is derived from the _first line_ which should begin with `#` to
    signify the top-level heading.
- Slugs are bare e.g., `/my-cool-post` _not_ `/posts/2021/my-cool-post`.

## Structure

For a fully-featured example, view the demo source code: <https://github.com/Pinjasaur/bic-example>

## Config

`bic` uses an `.env` pattern. This let's you configure required variables and add
any extras that can be used within your templates. Talk about batteries included.

Required config (you'll have a bad time with the defaults):

- `SITE_TITLE` e.g., `My Cool Site` (the site's title)
- `SITE_URL` e.g., `https://mycool.site` (the site's full base URL with _no_ trailing slash)
- `TIMEZONE` e.g., `US/Central` (the timezone you're in)
- `SALT` e.g. `super-random-abcxyz` (used to seed the [Hashids] encoding)

Optional, but you'll probably want to change:

- `DATE_FORMAT` e.g., `+%B %d, %Y` (passed into `date`, default: `YYYY-MM-DD`)
- `BUILD_DIR` e.g., `_site` (configure output directory, default: `build`)

## Templating

Anything listed above or added additionally to a `.env` will be available
_globally_ within templates.

Some specific keys used within entries (posts or drafts) and pages:

- `slug`, to be used in URL
- `title`, taken from first line of file `# ...`
- `date`, literally the `mtime` of the file
- `id`, the digit sequence for an entry encoded with [Hashids]
- `body`, converted Markdown to HTML contents (sans title)

[Pandoc]: https://pandoc.org/
[Mustache]: https://mustache.github.io/mustache.5.html
[Mo]: https://github.com/tests-always-included/mo
[Hashids]: https://hashids.org/
