haproxy_file:
  file.append:
    - name: /tmp/haproxy_file
    - source: salt://haproxy.cfg
