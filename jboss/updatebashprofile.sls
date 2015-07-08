{% from "jboss/files/map.jinja" import users with context %}
{% from "jboss/files/map.jinja" import dir with context %}

{{ users.home }}/.bashrc:
  file.append:
    - text:
        - export JAVA_HOME= {{ dir.java_dir }}/jdk1.7.0_65
