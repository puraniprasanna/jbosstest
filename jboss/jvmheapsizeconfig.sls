{% from jboss/files/map.jinja import dir with context %}
{% from jboss/files/map.jinja import jboss with context %}
{% from jboss/files/map.jinja import data with context %}

edit_heapsize:
  file.replace:
    - name: {{ dir.jboss_final_dir }}/server/{{ data.jvm_name }}/standalone.conf
    - pattern: ' JAVA_OPTS="-Xms64m -Xmx512m -XX:MaxPermSize=256m -Djava.net.preferIPv4Stack=true"'
    - repl: ' JAVA_OPTS="-Xms{{ data.min_heapsize }}m -Xmx{{ data.max_heapsize }}m -XX:MaxPermSize=256m -Djava.net.preferIPv4Stack=true"'
edit_ajpconnections:
  file.replace:
     - name: {{ dir.jboss_final_dir }}/server/{{ data.jvm_name }}/configuration/standalone.xml
     - pattern: ' <connector name="ajp" protocol="AJP/1.3" scheme="http" socket-binding="ajp" max-connections="50"/>'
     - repl: ' <connector name="ajp" protocol="AJP/1.3" scheme="http" socket-binding="ajp" max-connections="{{ data.ajp_max_connections }}"/>'