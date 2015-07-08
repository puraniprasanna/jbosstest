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
  module.run:
    - name: archive.tar
    - options: zxvf
    - tarfile: {{ dir.java_file }}
    - dest: {{ dir.java_dir }}
    - require:
      - cmd: java_file_check
