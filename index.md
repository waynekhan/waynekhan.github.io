---
layout: default
---

Hello, thanks for visiting. You might want to check out some of my content then:

## Posts

<ul>
  {% for post in site.posts %}
    <li>
      <a href="{{ post.url }}">{{ post.title }}</a>
    </li>
  {% endfor %}
</ul>

## Pages

* [About Wayne](/about)
* [Docker Cheatsheet](/docker-cheatsheet)
