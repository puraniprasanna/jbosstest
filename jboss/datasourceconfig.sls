{% from jboss/map.jinja import data with context %}

editjndiname:
  file.replace:
     - name: {{ data.jboss_final_dir }}/server/{{ data.jvm_name }}/configuration/standalone.xml
     - pattern: 'datasource jndi-name="java:jboss/datasources/ExampleDS" pool-name="ExampleDS" enabled="true" use-java-context="true"'
     - repl: 'datasource jndi-name="{{ data.JNDI_NAME }}" pool-name="{{ data.POOL_NAME }}" enabled="true" use-java-context="true"'
editconnectionurl:
  file.replace:
     - name: {{ data.jboss_final_dir }}/server/{{ data.jvm_name }}/configuration/standalone.xml
     - pattern: 'connection-url>jdbc:h2:mem:test;DB_CLOSE_DELAY=-1</connection-url'
     - repl: 'connection-url>{{ data.CONNECTION_URL }}</connection-url'
editdriverdatasource:
  file.replace:
     - name: {{ data.jboss_final_dir }}/server/{{ data.jvm_name }}/configuration/standalone.xml
     - pattern: 'driver>h2</driver'
     - repl: 'driver>{{ data.driver_name }}</driver'
editusername:
  file.replace:
     - name: {{ data.jboss_final_dir }}/server/{{ data.jvm_name }}/configuration/standalone.xml
     - pattern: 'user-name>sa</user-name'
     - repl: 'user-name>{{ data.USER_NAME }}</user-name'
editpassword:
  file.replace:
     - name: {{ data.jboss_final_dir }}/server/{{ data.jvm_name }}/configuration/standalone.xml
     - pattern: 'password>sa</password'
     - repl: 'password>{{ data.PASS_WORD }}</password'
