---
layout: default
title: Extracting PDF page ranges using pdftk
---

## Extracting PDF page ranges using pdftk

I needed to extract parts of a big PDF file today, learned about the existence of `pdftk` on Ask Ubuntu:

[https://askubuntu.com/questions/221962/how-can-i-extract-a-page-range-a-part-of-a-pdf](https://askubuntu.com/questions/221962/how-can-i-extract-a-page-range-a-part-of-a-pdf)

Oh, and it can be installed using `sudo snap install pdftk`, pretty handy if you're on Ubuntu.

So the highest rated answer was good, but I wanted to combine multiple page ranges of my big PDF file. Following is what I used successfully to extract 3 separate page ranges of `foo.pdf` (as `bar.pdf`):

```bash
$ pdfk cat foo.pdf 39-43 46-47 50 output bar.pdf
```
