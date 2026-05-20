# DDEV Apache Solr for TYPO3 — `release-13.1.x`

> **All documentation lives on `main`.**
> See the [`main` branch README](https://github.com/TYPO3-Solr/solr-ddev-site/blob/main/README.md) for contributor onboarding, workshop preparation, project structure, addons, backend modules, etc.
>
> **Only difference on this branch:** the DDEV project is named **`solr-13.1`** (URLs are `https://solr-13.1.ddev.site/…`).
>
> **Check this branch out into its own directory and open it as a separate IDE project** — a `main` and a `release-13.1.x` checkout cannot live in the same folder. Clone with an explicit target path, for example:
>
> ```bash
> git clone -b release-13.1.x git@github.com:TYPO3-Solr/solr-ddev-site.git ~/PhpstormProjects/solr-ddev-site.13.1
> cd ~/PhpstormProjects/solr-ddev-site.13.1
> ddev start
> ```
>
> Maintainers typically use this layout for parallel checkouts:
>
> ```
> ~/PhpstormProjects/solr-ddev-site.main    # main branch       → DDEV name: solr-ddev-site
> ~/PhpstormProjects/solr-ddev-site.13.1    # release-13.1.x    → DDEV name: solr-13.1
> ```
>
> Both DDEV projects can then run simultaneously, each with its own containers and URLs.

## Keep this branch up to date

`ddev clone` sets `https://github.com/TYPO3-Solr/…` as `upstream` automatically on first clone (for both `solr-ddev-site` and `packages/ext-solr`). Pull upstream changes regularly to stay in sync with `release-13.1.x`:

```bash
git pull --rebase upstream release-13.1.x
cd packages/ext-solr && git pull --rebase upstream release-13.1.x
cd ../../
ddev start
```

> **Linear history:** EXT:solr* repositories use a linear history — always `git rebase`, never `git merge`.
