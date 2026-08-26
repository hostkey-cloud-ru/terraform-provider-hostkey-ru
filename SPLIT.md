# Split: hostkey-ru + hostkey-com

Current tree is the **RU** fork (`terraform-provider-hostkey-ru`).  
Sibling checkout: `../terraform-provider-hostkey-com` (COM).

| | RU | COM |
|--|----|-----|
| GitHub | `hostkey-cloud-ru/terraform-provider-hostkey-ru` | `hostkey-cloud/terraform-provider-hostkey-com` |
| Registry | `registry.terraform.io/hostkey-cloud-ru/hostkey-ru` | `…/hostkey-com` |
| InvAPI | `https://invapi.hostkey.ru/` only | `https://invapi.hostkey.com/` only |
| Docs | Russian, hostkey.ru | English, hostkey.com |
| TypeName | `hostkey` (resources `hostkey_*`) | same |

## Breaking (v0.2.0)

- `source` is no longer `hostkey-cloud/hostkey` (deprecated).
- Provider attribute `region` removed; install the matching provider instead.
- `base_url` may override staging/localhost; the other portal’s host is rejected.

## Consumer migration

```hcl
terraform {
  required_providers {
    hostkey = {
      source  = "hostkey-cloud-ru/hostkey-ru" # or hostkey-com
      version = "~> 0.2"
    }
  }
}
provider "hostkey" {
  api_key = var.hostkey_api_key
}
```

```bash
terraform state replace-provider \
  'registry.terraform.io/hostkey-cloud/hostkey' \
  'registry.terraform.io/hostkey-cloud-ru/hostkey-ru'
```

## Fork-specific code

- [`internal/invapi/portal.go`](internal/invapi/portal.go) — default URL, allowed TLD, sibling provider error
- [`main.go`](main.go) `Address`
- `go.mod` module path
- Makefile binary / User-Agent
- README + `docs/` language and links

## GitHub / Registry (manual)

1. Rename this repo to `terraform-provider-hostkey-ru` (keep v0.1.x tags).
2. Create empty `terraform-provider-hostkey-com`, push the COM tree, add GoReleaser GPG secrets.
3. Register both providers on Terraform Registry (`hostkey-ru`, `hostkey-com`).
4. Stop publishing tags that release to old `hostkey-cloud/hostkey`.
5. Tag **v0.2.0** on each **after** `main` is committed, Registry publishers point at the new GitHub names, and GoReleaser GPG secrets exist on both repos.

## Touch-list (already applied in-tree)

- `go.mod` + all `github.com/hostkey-cloud-ru/terraform-provider-hostkey-ru` imports
- `main.go` Address `registry.terraform.io/hostkey-cloud-ru/hostkey-ru`
- Remove `region`; hardcode portal URL; portal allowlist
- CHANGELOG Unreleased / 0.2.0 note
- Agent memory: `AGENTS.md`, `.cursor/rules/hostkey-provider.mdc`

Hard ban: never ship server id **56909**.
