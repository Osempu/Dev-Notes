# AGENTS.md

## Project overview

`dev-notes` is a personal learning hub built with Astro. It is a static documentation site for recording new topics, explanations, and code examples as they are learned. Content is organized as MDX notes and presented through the Lotus documentation theme.

The production deployment target is Dokploy. The intended release flow is:

1. Work on a feature branch.
2. Open a pull request and merge the completed work into `master`.
3. GitHub Actions validates and builds the site.
4. A GitHub webhook invokes the Dokploy deployment hook after the accepted push to `master`.
5. Dokploy builds and redeploys the static site from the repository.

Keep the deployment path deterministic: the same repository revision merged into `master` should be the revision validated by CI and deployed by Dokploy.

## Repository map

- `src/content/docs/` — MDX learning notes and documentation pages.
- `src/content/docs/index.mdx` — the home/splash page because `docsBase` is `/`.
- `src/content/docs/overview.mdx` — the overview page at `/overview/`.
- `src/content.config.ts` — registers the Lotus `docs` content collection and schema.
- `theme.config.json` — site identity, navigation, search, footer, source links, and content grouping.
- `astro.config.ts` — Astro configuration and Lotus integration.
- `public/` — static assets such as the favicon.
- `.github/workflows/` — GitHub Actions automation.
- `dist/` — generated production output; never edit or commit it.
- `.astro/` — generated Astro metadata; never edit or commit it.
- `vercel.json` — legacy Vercel build/output configuration; it is not the Dokploy deployment configuration.

Current content groups include Start Here, Guides, Data Structures, and Algorithms. Add a new topic under the matching directory and add or update its entry in `theme.config.json` when it should appear in the sidebar.

## Local development

Use pnpm. The lockfile is `pnpm-lock.yaml`; keep it updated when dependencies change.

```sh
pnpm install
pnpm dev
pnpm check
pnpm build
pnpm preview
```

When starting the development server through the agent, use background mode:

```sh
astro dev --background
```

Manage the background server with:

```sh
astro dev status
astro dev logs
astro dev stop
```

Before merging content or configuration changes, run at least:

```sh
pnpm check
pnpm build
```

`pnpm check` validates Astro types and content schemas. `pnpm build` verifies that the production static output can be generated in `dist`.

## Writing and organizing notes

- Add notes as `.mdx` files below `src/content/docs/`.
- Include frontmatter with at least `title` and `description`.
- Use `sidebar.order` when ordering pages within a group; use `sidebar.hidden` for pages that should not appear in navigation.
- Put reusable code examples directly in the relevant note and label the language in fenced code blocks.
- Keep URLs and external links intentional; avoid leaving starter-template links in new content.
- Keep navigation directory names synchronized with the actual content directories. For example, the current directory is `data-structures`, and the navigation entry must use that exact directory name.
- Update `theme.config.json` when changing the site name, description, social/source links, navigation, footer, or search settings.

The project still contains starter-template copy and Prosefly links in `README.md`, `theme.config.json`, and some example MDX pages. Replace those references as the personal site is customized; do not treat the starter's Vercel button or example deployment page as the production deployment process.

## CI and Dokploy deployment

The desired CI/CD contract is:

- GitHub Actions runs on pushes to `master` and may be run manually.
- CI installs from the committed lockfile using a frozen install, runs `pnpm check`, and runs `pnpm build`.
- The build output is `dist`.
- Dokploy is connected to this repository and configured to deploy the `master` branch.
- Dokploy's GitHub hook is configured to trigger a deployment after a successful push to `master` (including a merge from a feature branch).
- The webhook URL/token must stay in GitHub/Dokploy secrets or protected settings; never commit it to this repository.
- Configure the webhook to receive only the required repository push events and validate its signature/token when the Dokploy setup supports validation.
- Do not create a second independent deployment path unless it is intentional. GitHub Pages, Vercel, and Dokploy should not all deploy the same production branch by accident.

Important current-state note: `.github/workflows/site.yml` currently targets GitHub Pages, listens to `main`, installs with `--no-lockfile`, and does not run `pnpm check`. It must be reconciled with the Dokploy plan before treating CI as authoritative: change the branch to `master`, use the lockfile, add validation, and remove or explicitly retain the GitHub Pages deployment only if it is wanted as a separate preview/backup environment. The `vercel.json` file is similarly legacy unless Vercel remains an intentional deployment target.

For Dokploy, use the repository's normal build settings unless the application configuration changes:

- Framework/build command: `pnpm build`
- Install command: `pnpm install --frozen-lockfile`
- Output directory: `dist`
- Production branch: `master`
- Runtime: a Node.js version compatible with the Astro and dependency versions in `package.json`

If Dokploy builds from a container or a custom Dockerfile in the future, document that file and keep its Node/pnpm versions aligned with CI. Do not assume that a successful local dev server means a production build succeeds.

## Astro and documentation references

Consult the official Astro documentation for changes involving:

- [Routing](https://docs.astro.build/en/guides/routing/)
- [Astro components](https://docs.astro.build/en/basics/astro-components/)
- [Framework components](https://docs.astro.build/en/guides/framework-components/)
- [Content collections](https://docs.astro.build/en/guides/content-collections/)
- [Styling and Tailwind](https://docs.astro.build/en/guides/styling/)
- [Internationalization](https://docs.astro.build/en/guides/internationalization/)

Prefer the existing content collection and Lotus theme conventions before introducing custom routing or a new content mechanism.

## Change and deployment checklist

1. Add or update the relevant MDX content and navigation.
2. Update site identity or links in `theme.config.json` when needed.
3. Run `pnpm check` and `pnpm build`.
4. Review the generated route and links with `pnpm preview` for navigation-heavy changes.
5. Commit to a feature branch and merge through the normal pull-request flow into `master`.
6. Confirm GitHub Actions passed.
7. Confirm the Dokploy hook triggered the expected revision and the deployed site loads correctly.

Avoid committing secrets, generated directories, build artifacts, or unrelated changes. Preserve existing user work in the working tree when making repository-wide documentation or configuration updates.
