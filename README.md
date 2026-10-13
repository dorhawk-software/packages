# dorhawk.software packages

The signed apt and dnf repository at **https://packages.dorhawk.software** for
[dorhawk.software](https://dorhawk.software)'s Linux apps. The start page there has the commands
to add it.

| App | Package |
|---|---|
| [Crake](https://github.com/dorhawk-software/crake) | `crake` |

## How it works

The apps build their own packages and publish them as GitHub releases. This repository turns the
latest release of each app in [`apps.json`](apps.json) into the repository:
[`.github/workflows/publish.yml`](.github/workflows/publish.yml) fetches the `.deb` and `.rpm`
files, tests them in containers (no network, a throwaway key), signs the RPMs, builds and signs the
apt and dnf indexes, uploads everything to a Cloudflare R2 bucket, and then installs from the live
site. Earlier versions stay in the repository.

It runs when an app's release asks (a `repository_dispatch` of type `release` with `repo` and
`tag`), on every push here, by hand, and hourly in case an ask was missed (stopping at once when
there's nothing new).

**Adding an app:** an entry in `apps.json`; its releases need a `.deb` (amd64) and an `.rpm`.

## The signing key

`dorhawk.software packages`, RSA 4096, signing only:

    B17A 7118 E977 36C2 02AD 5EAF  F1D1 52DA 1BBD 1C97

The public half is [`key.asc`](key.asc), served at `/key.asc`. The private half is the secret
`PACKAGES_GPG_KEY` and nowhere else but its owner's password manager.

## Running it

| Secret / variable | |
|---|---|
| `PACKAGES_GPG_KEY` (secret) | the private key, armored |
| `R2_ACCESS_KEY_ID`, `R2_SECRET_ACCESS_KEY` (secrets) | an R2 token: Object Read & Write on the bucket only |
| `R2_ACCOUNT_ID`, `R2_BUCKET` (variables) | the Cloudflare account and the bucket, `dorhawk-packages` |

`/` serves `index.html` through a Cloudflare URL rewrite rule on the dorhawk.software zone (R2
serves no index of its own).

Locally: `scripts/fetch-releases.sh dist && scripts/repo-test.sh dist` (needs `gh`, Docker, `jq`).
