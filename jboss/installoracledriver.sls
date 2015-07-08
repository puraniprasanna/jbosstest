{% from jboss/files/map.jinja import dir with context %}
{% from jboss/files/map.jinja import users with context %}

{{ dir.jboss_final_dir }}/modules/com/oracle/ojdbc14/main:
  file.directory:
    - user: {{ users.user }}
    - group: {{ users.group }}
    - mode: 755
    - makedirs: True
unziporaclejdbcdriver:
  cmd.run:
    - name: unzip {{ dir.jdbcdriver_file }} -d {{ dir.jboss_final_dir }}/modules/com/oracle/ojdbc14/main
    - onlyif: 'test -d {{ dir.jboss_final_dir }}/modules/com/oracle/ojdbc14/main'

