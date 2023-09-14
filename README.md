# Typst in Nix

![typst](https://img.shields.io/badge/typst-0.7.0-orange)
![typst-lsp](https://img.shields.io/badge/typst--lsp-0.9.5-orange)
[![Test](https://github.com/Wybxc/typst-nix/actions/workflows/test.yml/badge.svg)](https://github.com/Wybxc/typst-nix/actions/workflows/test.yml)

Typst's humble yet comprehensive environment: an accommodating space for crafting papers and presentations, offering a range of fonts and templates.

## Usage

```sh
nix develop github:Wybxc/typst-nix
```

Then enjoy it!

### Cachix binary cache (optional)

During each GitHub Actions run, a pre-built binary cache is pushed to my Cachix cache. If you trust its reliability, feel free to utilize it to expedite the installation process.

```sh
cachix use wybxc
```

## Features / Todos

- Fonts
  - [x] 思源宋体 (Source Han Serif)
  - [x] Inria Serif
  - [x] 思源黑体 (Source Han Sans)
  - [x] Inria Sans
  - [x] Fira Code
- Templates
  - [x] Slides
  - [x] Handout
  - [ ] Paper

## Known Issues

None yet.

<details>
<summary>Previous Issues</summary>

The following issues used to exist in the previous version of this repository. They have been fixed in 0.2.0.

- Currently, Typst does not have support for adding multiple font paths through environment variables (refer to [typst/typst#100](https://github.com/typst/typst/issues/100)). As a workaround, I have created a wrapper script that adds the font path to the command line arguments. Although this solution is not ideal, it does the job.

- Typst-lsp does not function properly with `TYPST_ROOT`. This issue is documented in [nvarner/typst-lsp#98](https://github.com/nvarner/typst-lsp/issues/98) and [nvarner/typst-lsp#120](https://github.com/nvarner/typst-lsp/issues/120). As a result, the language server fails to discover the templates, leading to the unavailability of the completion feature.

</details>

## Upgrading

### 0.1.0 -> 0.2.0

* Replace `#import "/slides/slide.typ"` with `#import "@preview/polylux:0.3.1"`. There may be API changes from typst-slides to polylux, so please refer to the [polylux documentation](https://andreaskroepelin.github.io/polylux/book/polylux.html).
* For typst-lsp VSCode extension, please modify the configuration file to use the wrapper script `typst-lsp`. Otherwise, the language server will not be able to discover the templates.

## Changelog

### 0.2.0

* Update to typst 0.7.0
* Add wrapper script for typst-lsp
* Templates: Slides([polylux](https://github.com/andreasKroepelin/polylux) from typst published packages), Handout
* **Breaking change**: now templates are imported via typst's package system

### 0.1.0

* Initial release
* Support typst 0.5.0
* Fonts: Source Han Serif, Inria Serif, Source Han Sans, Inria Sans, Fira Code
* Templates: Slides(from https://github.com/andreasKroepelin/typst-slides)
