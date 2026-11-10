# dev-notes

Starter template for building documentation sites with
[`@prosefly/astro-theme-lotus`](https://github.com/prosefly/astro-theme-lotus).

## Deploy

The production deployment target is Dokploy. Dokploy should track the `master`
branch and build the repository with the included `Dockerfile`. The container
serves the generated static site on port `8081`.

The GitHub Actions workflow validates the Astro project and builds/scans the
container on pull requests and pushes to `master`. Configure Dokploy's GitHub
webhook to deploy after a successful push to `master`; keep its URL and token in
protected GitHub/Dokploy settings.

## Local development

```sh
pnpm install
pnpm dev
```

## Project Structure

```text
src/
  content.config.ts      Registers the Lotus docs collection
  content/docs/          Your MDX documentation pages
theme.config.json        Configures navigation, docs navigation, search, and footer
```

Lotus reads MDX files from `src/content/docs` by default. This starter sets
`docsBase: '/'`, so `src/content/docs/index.mdx` renders as the site homepage at
`/`, and the docs entry page renders at `/overview/`.

## Commands

| Command | Description |
| --- | --- |
| `pnpm dev` | Start the local dev server. |
| `pnpm build` | Build the production site. |
| `pnpm preview` | Preview the production build locally. |
| `pnpm check` | Run Astro type and content checks. |

## Customize

Edit `theme.config.json` to change the site name, navigation, docs navigation,
appearance, search, footer links, and source links.
