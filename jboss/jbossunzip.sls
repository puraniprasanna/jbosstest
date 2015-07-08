{% from "jboss/files/map.jinja" import dir with context %}
{% from "jboss/files/map.jinja" import users with context %}

{{ dir.jboss_final_dir }}:
  file.directory:
    - user: {{ users.user }}
    - group: {{ users.group }}
    - mode: 755
    - recurse:
      - user
      - group

{{ dir.jboss_dir }}/admin:
  file.directory:
    - user: {{ users.user }}
    - group: {{ users.group }}
    - mode: 755
    - recurse:
      - user
      - group

unzip_jbosssoftware:
  cmd.run:
    - name: unzip {{ dir.jboss_final_file }} -d {{ dir.jboss_dir }}
    - onlyif: 'test -d {{ dir.jboss_dir }}'

metainf_cleanup:
  cmd.run:
    - name: 'rm -rf {{ dir.jboss_dir }}/META-INF'

#unzip_adminjobss:
#  cmd.run:
#    - name: unzip {{ dir.jboss_admin_file }} -d {{ dir.jboss_dir }}
#    - onlyif: 'test -d {{ dir.jboss_dir }}'
