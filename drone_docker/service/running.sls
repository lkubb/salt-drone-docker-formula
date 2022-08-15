# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- from tplroot ~ "/map.jinja" import mapdata as drone_docker with context %}

include:
  - {{ sls_config_file }}

Drone Docker Runner service is enabled:
  compose.enabled:
    - name: {{ drone_docker.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if drone_docker.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ drone_docker.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
    - require:
      - Drone Docker Runner is installed
{%- if drone_docker.install.rootless %}
    - user: {{ drone_docker.lookup.user.name }}
{%- endif %}

Drone Docker Runner service is running:
  compose.running:
    - name: {{ drone_docker.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if drone_docker.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ drone_docker.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if drone_docker.install.rootless %}
    - user: {{ drone_docker.lookup.user.name }}
{%- endif %}
    - watch:
      - Drone Docker Runner is installed
