---
layout: default
title: Extracting PDF page ranges using pdftk
---

## Extracting PDF page ranges using pdftk

I needed to extract parts of a big PDF file today, learned about the existence of `pdftk`, a command-line interface tool for manipulating PDFs on Ask Ubuntu:

[https://askubuntu.com/questions/221962/how-can-i-extract-a-page-range-a-part-of-a-pdf](https://askubuntu.com/questions/221962/how-can-i-extract-a-page-range-a-part-of-a-pdf)

Conveniently, it can be installed using `sudo snap install pdftk`.

I wanted to combine multiple page ranges of my big PDF file. so so to self:

```bash
$ pdfk cat foo.pdf 39-43 46-47 50 output bar.pdf
```
