# Notes

- `slug`, to be used in URL
- `title`, taken from first line of file `# ...`
- `date`, literally the mtime of the file
- `id`, the leading number of filename (maybe use hashids?)
- `body`, converted Markdown to HTML contents (sans title)

What whould be escaped? slugified? title-cased?

Excerpt? Description (to fill `meta` tag`?)?
https://mgdm.net/weblog/htmlq/

The naming pattern of pages, posts, and drafts is critical:

- Starts with a digit sequence. Recommend 3 or 4 for Future Proof&trade;.
    - This starts at the _highest_ number and decrements for each post.
    - Otherwise, posts will be listest out of order.
- Filename after the leading digit will be used to create the slug.

`.env` support?

- `{{SITE_TITLE}}` e.g., `My Cool Site`
- `{{SITE_URL}}` e.g., `https://mycool.site`
- `{{DATE_FORMAT}}` whatever is passed to `date`
- `{{TIMEZONE}}` e.g., `US/Central`
- `{{SALT}}` e.g. `super-random-abcxyz`

docker.pkg.github.com can't be deleted? ghcr.io seems to be the way to go, for
now at least, because it does public anon pulls.
