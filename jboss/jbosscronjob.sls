{% from jboss/files/map.jinja import users with context %}
{% from jboss/files/map.jinja import dir with context %}

cron-entry-for-jboss:
 cron.present:
   - user: {{ users.user }}
   - name: '{{ dir.appserver_bin }}/jboss_purge_log_files.sh > /dev/null'
   - minute: '0'
   - hour: '22'
   - daymonth: '*'
   - month: '*'
   - dayweek: '*'
   - identifier: 'purge jboss logs'
   - comment: 'Installed via Salt'
