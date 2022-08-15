# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as drone_docker with context %}

drone_docker service is dead:
  compose.dead:
    - name: {{ drone_docker.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if drone_docker.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ drone_docker.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if drone_docker.install.rootless %}
    - user: {{ drone_docker.lookup.user.name }}
{%- endif %}

drone_docker service is disabled:
  compose.disabled:
    - name: {{ drone_docker.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if drone_docker.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ drone_docker.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if drone_docker.install.rootless %}
    - user: {{ drone_docker.lookup.user.name }}
{%- endif %}
