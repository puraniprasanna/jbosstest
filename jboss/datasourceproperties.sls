{% from jboss/files/map.jinja import dir with context %}
{% from jboss/files/map.jinja import data with context %}

editdrivernameandmodule:
  file.replace:
     - name: {{ dir.jboss_final_dir }}/server/{{ data.jvm_name }}/configuration/standalone.xml
     - pattern: ' <driver name="h2" module="com.h2database.h2">'
     - repl: ' <driver name="{{ data.driver_name }}" module="{{ data.module }}">'
editxadatasourceclass:
  file.replace:
     - name: {{ dir.jboss_final_dir }}/server/{{ data.jvm_name }}/configuration/standalone.xml
     - pattern: ' <xa-datasource-class>org.h2.jdbcx.JdbcDataSource</xa-datasource-class>'
     - repl: ' <xa-datasource-class>{{ data.xa_datasource_class }}</xa-datasource-class>'
editpoolsize:
  file.replace:
     - name: {{ dir.jboss_final_dir }}/server/{{ data.jvm_name }}/configuration/standalone.xml
     - pattern: ' <max-pool-size>5</max-pool-size>'
     - repl: ' <max-pool-size>{{ data.datasource_poolsize }}</max-pool-size>'
