---
layout: default
title: Home
permalink: /
---

Hello, thanks for visiting! You may want to check out some of my content (list below), or get an [RSS feed](https://waynekhan.net/feed.xml) for your favourite reader.

# Posts

<ul>
  {% for post in site.posts %}
    <li><a href="{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>

# Pages

* [Docker Cheatsheet](/docker-cheatsheet)
* [About Wayne](/about)
