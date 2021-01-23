# Notes

`{{entries}}` is a function to iterate `all_entries`:

- `slug`, to be used in URL
- `title`, taken from first line of file `# ...`
- `date`, literally the mtime of the file
- `id`, the leading number of filename (maybe use hashids?)
- `body`, converted Markdown to HTML contents (sans title)

The naming pattern of pages, posts, and drafts is critical:

- Starts with a digit sequence. Recommend 3 or 4 for Future Proof&trade;.
    - This starts at the _highest_ number and decrements for each post.
    - Otherwise, posts will be listest out of order.
- Filename after the leading digit will be used to create the slug.
