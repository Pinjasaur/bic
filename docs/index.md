<div align="center">
  <img width="256" src="logo.png" alt="bic">
</div>

# Docs <small style="opacity: .7; font-size: .5em"><span class="js-release"></span></small>

`bic` is an opinionated and minimal static site generator&mdash;with a focus on
blogs. View the [demo] or the [source].

{% raw %}
It uses [Pandoc] to convert plain Markdown files into HTML. They get templated
{{[Mustache]}}-style with [Mo]. [Hashids] is used to generate IDs.
{% endraw %}

## Basics

You get the (opinionated) basics of a static site/blog (read: opinionated):

- pages e.g., `pages/about.md` &rarr; `/about.html`
- posts e.g., `posts/999-first-post.md` &rarr; `/first-post.html`
- drafts e.g., `drafts/998-untitled.md` &rarr; `/drafts/untitled.html`
- static content e.g., `static/*` &rarr; `/*`
- robots.txt
- sitemap.xml
- RSS feed
- tags for organizing entries

For reproducible builds, I would recommend using `bic` with Docker: `ghcr.io/pinjasaur/bic:latest`

Essentially, mount your source directory to `/src`

```bash
docker run --rm -v "$PWD":/src ghcr.io/pinjasaur/bic:latest
```

to spit out a `build` directory with your generated site.

Alternatively, `bic` is available as a [nix flake].

Follow the [setting up flakes] guide to enable it, then run 

```bash
nix run github:Pinjasaur/bic --command bic .
```

to run `bic` in the current directory and spit out a `build` directory with your
generated site.

## Opinionated?

`bic` is strict where necessary to keep it opinionated with a lean scope.

- Pages exist in `pages/*.md`. Not nested.
- Posts & drafts exist within `posts/*.md` and `drafts/*.md`, respectively.
  - _Ordering_ is determined by a number prefix e.g., `999-post.md`
  for the first post, `998-tacocat.md` for the second, et cetera. I would
  recommend 3 or 4 digits for the Future Proof&trade;.
  - This lets the file `mtime` be used for the author's discretion. However,
  Git [doesn't record `mtime`][mtime], so I would treat it as the "last
  modified" date.
  - The title is derived from the _first line_ which MUST begin with `#` to
  signify the top-level heading.
  - Entries can be organized via tags, which MUST be defined _immediately_
  below the title using syntax such like: `tags: foo, bar-baz`.
- Slugs are bare e.g., `/my-cool-post` _not_ `/posts/2021/my-cool-post.html`.

## Structure

For a fully-featured example, view the demo source code: <https://github.com/Pinjasaur/bic-example>

```plaintext
$ tree -F --dirsfirst
.
├── drafts/
│   └── 997-untitled.md
├── pages/
│   └── about.md
├── posts/
│   ├── 998-foo-bar.md
│   └── 999-hello-world.md
├── static/
│   ├── css/
│   │   └── style.css
│   ├── img/
│   │   └── photo.jpg
│   └── js/
│       └── script.js
├── __feed.rss
├── __index.html
├── _footer.html
├── _head.html
├── _header.html
├── entry.html
├── feed.rss
├── index.html
├── page.html
├── robots.txt
└── sitemap.xml
```

## Config

`bic` uses an `.env` pattern. This lets you configure ~~required~~ variables and add
any extras that can be used within your templates. Talk about batteries included.

A `.env` file simply contains lines of `KEY=value` pairs. If you, for whatever
reason, want to supply an environment variable at runtime _and_ have it
override your `.env` then use syntax such like:

```bash
ENV_VAR="${ENV_VAR:-default value}"
```

Not-100%-required but highly-recommended config:

- `SITE_AUTHOR` e.g. `Captain Anonymous` (the site's author)
- `SITE_TITLE` e.g., `My Cool Thing` (the site's title)
- `SITE_URL` e.g., `https://domain.tld` (the site's full base URL with _no_ trailing slash)

Optional, change if needed:

- `BIC_OVERWRITE` (disable file overwrite protection, see [#caveats](#caveats), default: unset)
- `BUILD_DIR` e.g., `_site` (configure output directory, default: `build`)
- `DATE_FORMAT` e.g., `+%B %d, %Y` (passed into `date`, default: `+%F` &rarr; `YYYY-MM-DD`)
- `SALT` e.g. `super-random-abcxyz` (used to seed the [Hashids] encoding, default: `bic`)
- `TIMEZONE` e.g., `US/Central` (the [timezone] you're in, default: `US/Central`)

## Templating

Anything listed above or added additionally to a `.env` will be available
_globally_ within templates.

Some specific keys used within entries (posts or drafts) and pages:

- `slug`, to be used in URL (does _not_ contain the `.html` file extension)
- `title`, taken from first line of file `# ...`
- `date`, literally the `mtime` of the file
- `id`, the number prefix for an entry encoded with [Hashids]
- `body`, converted Markdown to HTML contents (sans title)

Drafts will have a `draft` key set. Likewise, posts will have a `post` key set.

Each entry in `posts/*.md` or `drafts/*.md` is rendered against an `entry.html`.

Each page in `pages/*.md` is rendered against a `page.html`.

{% raw %}
`index.html`, `feed.rss`, and `tag.html` use a [double-underscore-prefixed]
template partial of the same name e.g., `{{__index}}` from `__index.html`.
{% endraw %}

`tags.html` has access to an associative array of `all_tags` mapped to the
number of entries tagged by that tag.

`sitemap.xml` has access to an array of slugs with the `slugs` key.

## Caveats

There is an order-of-operations for how files are built, as follows:

- pages e.g. `pages/*.md`
- posts e.g. `posts/*.md`
- drafts e.g. `drafts/*.md`
- tags (all tags and tagged entries)
- `index.html`
- `sitemap.xml`
- `robots.txt`
- `feed.rss`
- static e.g. `static/*` &rarr; `/`

If you're not careful, it's possible you could overwrite an existing
file e.g. `pages/test.md` and `posts/999-test.md` both map to `/test.html`. `bic`
uses the Bash builtin `noclobber` e.g. `set -o noclobber` to help prevent these
situations. This can be disabled by setting `BIC_OVERWRITE`.

## Showcase

`bic` in the wild:

- the demo: <https://demo.bic.sh/>
- Mitch's blog: <https://fossen.dev/>
- Evan's blog: <https://evanhstanton.github.io/>

## Support

`bic` is built & maintained by [Paul].

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/X8X23K1V6)

[Pandoc]: https://pandoc.org/
[Mustache]: https://mustache.github.io/mustache.5.html
[Mo]: https://github.com/tests-always-included/mo
[Hashids]: https://hashids.org/
[nix flake]: https://www.tweag.io/blog/2020-05-25-flakes
[setting up flakes]: https://nixos.wiki/wiki/Flakes
[double-underscore-prefixed]: https://paul.af/applying-hungarian-notation-to-mustache-partials
[demo]: https://demo.bic.sh/
[source]: https://github.com/Pinjasaur/bic
[mtime]: https://stackoverflow.com/questions/1964470/whats-the-equivalent-of-subversions-use-commit-times-for-git/1964508#1964508
[timezone]: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
[Paul]: https://paulisaweso.me/

<script>
(async () => {
  const response = await fetch(`https://api.github.com/repos/pinjasaur/bic/releases`)
  const releases = await response.json()
  document.querySelectorAll(`.js-release`).forEach($el => $el.textContent = releases[0].tag_name)
  document.querySelectorAll(`code`).forEach($el => $el.innerHTML = $el.innerHTML.replace(`bic:latest`, `bic:${releases[0].tag_name.replace(/^v/, '')}`))
})();
</script>
