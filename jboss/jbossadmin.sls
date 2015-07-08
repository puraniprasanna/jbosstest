{% from jboss/files/map.jinja import data with context %}
{% from jboss/files/map.jinja import dir with context %}

{{dir.appserver_bin }}/jbosstab:
  file.append:
    - text: '{{ data.jvm_name }}:{{ dir.keystore_location }}../:Y:9999:admin:{{ salt['cmd.run']('hostname -i') }}:::2'

{{ dir.jboss_dir }}/setenv_jboss:
  file.copy:
    - source: {{ dir.appserver_bin }}/setenv_jboss
