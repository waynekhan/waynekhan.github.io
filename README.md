---
layout: default
title: Home
permalink: /
---

Hello, thanks for visiting! You may want to check out some of my content, or [get an RSS feed](/feed.xml) for your favourite reader.

## Posts

<ul>
  {% for post in site.posts %}
    <li>
      <p><a href="{{ post.url }}">{{ post.title }}</a></p>
      <div>{{ post.text }}</div>
    </li>
  {% endfor %}
</ul>

## Pages

- [About Wayne](/about-wayne.html)
- [Docker Cheatsheet](/docker-cheatsheet.html)
- [Dunning-Kruger effect](/dunning-kruger-effect.html)
- [(Fun with) Vagrant](/vagrant-fun.html)
- [(What are questions?](/what-are-questions.html)
