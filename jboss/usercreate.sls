{% from "jboss/files/map.jinja" import users with context %}

{{ users.group }}:
  group.present
{{ users.user }}:
  user.present:
    - home: {{ users.home }}
    - require:
      - group: {{ users.group }}
