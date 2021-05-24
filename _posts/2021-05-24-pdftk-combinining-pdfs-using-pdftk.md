---
layout: default
title: Combining (multiple) PDFs using pdftk
---

## Combining (multiple) PDFs using pdftk

Previously, I needed to [extract multiple ranges from a big PDF](https://waynekhan.github.io/2020/06/24/extracting-pdf-page-ranges-using-pdftk.html).

Now I want to use `pdftk` to combine two PDFs into a single file in order to support a claim, and this worked for me:

```text
pdftk A=foo.pdf B=bar.pdf cat A1 B3 output baz.pdf
```

