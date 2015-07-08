{% import jboss/files/map.jinja import data with context %}

jboss_start:
  cmd.run:
    - cwd: /appserver/admin/bin
    - name: ./jboss_start.sh {{ data.jvm_name }} 

