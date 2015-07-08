{% from "jboss/files/map.jinja" import dir with context %}
{% from "jboss/files/map.jinja" import users with context %}

{{ dir.java_dir }}:
  file.directory:
    - user: {{ users.user }}
    - group: {{ users.group }}
    - mode: 755
    - makedirs: True

java_file_check:
  cmd.run:
    - name: echo "Java software is not available in {{ dir.java_file }} "
    - onlyif: 'test ! -e  {{ dir.java_file }}'

unzip_jdksoftware:
  archive.extracted:
    - name: {{ dir.java_dir }}/
    - source: {{ dir.java_file }}
    - archive_format: tar
    - tar_options: v
