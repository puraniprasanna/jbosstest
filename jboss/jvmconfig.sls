{% from jboss/files/map.jinja import dir with context %}
{% from jboss/files/map.jinja import users with context %}
{% from jboss/files/map.jinja import data with context %}

{{ dir.jboss_final_dir }}/server/{{ data.jvm_name }}:
  file.directory:
    - user: {{ users.user }}
    - group: {{ users.group }}
    - mode: 755
    - makedirs: True
jvm_app01copy:
  cmd.run:
    - name: ' cp -rf {{ dir.jboss_final_dir }}/server/DSWEB-template/* {{ dir.jboss_final_dir }}/server/{{ data.jvm_name }}'
editstandalone-full.xml:
  file.replace:
     - name: {{ dir.jboss_final_dir }}/server/{{ data.jvm_name }}/configuration/standalone-full.xml
     - pattern: ' <connector name="remoting-connector" socket-binding="remoting" security-realm="ApplicationRealm"/>'
     - repl: ' <connector name="remoting-connector" socket-binding="remoting"/>'
editstandalone.xml:
  file.replace:
    - name: {{ dir.jboss_final_dir }}/server/{{ data.jvm_name }}/configuration/standalone.xml
    - pattern: ' key-alias="default"'
    - repl: ' key-alias="{{ salt['cmd.run']('hostname -s') }}"'

updateJAVA_HOME:
  file.replace:
    - name: {{ dir.jboss_final_dir }}/server/{{ data.jvm_name }}/standalone.conf
    - pattern: 'JAVA_HOME="{{ dir.java_dir }}/jdk\d\.\d\.\d\_\d\d"'
    - repl: ' JAVA_HOME="{{ dir.java_dir }}/jdk1.7.0_65"'

#Enable Garbage collection and setup GClog
standalone.conf:
  file.append:
    - name: {{ dir.jboss_final_dir }}/server/{{ data.jvm_name }}/standalone.conf
    - text:
        - JAVA_OPTS="$JAVA_OPTS -verbose:gc -XX:+PrintGCTimeStamps -XX:+PrintGCDetails -XX:+PrintGCApplicationStoppedTime -XX:+PrintGCApplicationConcurrentTime -Xloggc:{{ dir.jboss_final_dir }}/server/{{ data.jvm_name }}/log/gc_app_01.log"
