---
layout: default
title: Home
permalink: /
---

# Wayne Khan

Hello, thanks for visiting! You might want to check out some of my content:

## Posts

<ul>
  {% for post in site.posts %}
    <li>
      <a href="{{ post.url }}">{{ post.title }}</a>
    </li>
  {% endfor %}
</ul>

## Pages

* [Docker Cheatsheet](/docker-cheatsheet)
* [About Wayne](/about)
