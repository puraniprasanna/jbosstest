{% from "jboss/files/map.jinja" import dir with context %}
{% from "jboss/files/map.jinja" import ssl with context %}

ssl_keystore:
  file.absent:
    - name: {{ dir.keystore_location }}/ssl.keystore

jbosssslcertcreate:
  cmd.run:
    - cwd: {{ dir.keystore_location }}
    - name: ' keytool -genkey -keystore ssl.keystore -storepass {{ ssl.storepass }}  -keypass {{ ssl.keypass }}  -alias "{{ salt['cmd.run']('hostname -s') }}"  -keyalg RSA -keysize 2048 -validity 7300 -dname "cn={{ salt['grains.get']('localhost') }}"'
