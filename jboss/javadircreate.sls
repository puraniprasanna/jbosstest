{% from "jboss/files/map.jinja" import dir with context %}
{% from "jboss/files/map.jinja" import users with context %}

{{ dir.root_dir }}:
  file.directory:
    - user: {{ users.user }}
    - group: {{ users.group }}
    - mode: 755
    - makedirs: True
    - recurse:
      - user
      - group

{{ dir.java_dir }}:
  file.directory:
    - user: {{ users.user }}
    - group: {{ users.group }}
    - mode: 755
    - makedirs: True
    - require:
      - file: {{ dir.root_dir }}
    - recurse:
      - user
      - group

