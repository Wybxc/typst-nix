# Typst in Nix

Typst's humble yet comprehensive environment: an accommodating space for crafting papers and presentations, offering a range of fonts and templates.

## Usage

```sh
nix develop github:Wybxc/typst-nix
```

Then enjoy it!

## Features / Todos

- Fonts
  - [x] 思源宋体 (Source Han Serif)
  - [x] Inria Serif
  - [x] 思源黑体 (Source Han Sans)
  - [x] Inria Sans
  - [x] Fira Code
- Templates
  - [ ] Slides
  - [ ] Homework
  - [ ] Paper

## Known Issues

Currently, Typst does not have support for adding multiple font paths through environment variables (refer to [typst/typst#100](https://github.com/typst/typst/issues/100)). As a workaround, I have created a wrapper script that adds the font path to the command line arguments. Although this solution is not ideal, it does the job.
