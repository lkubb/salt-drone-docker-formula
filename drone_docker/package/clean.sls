# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_clean = tplroot ~ '.config.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as drone_docker with context %}

include:
  - {{ sls_config_clean }}

Drone Docker Runner is absent:
  compose.removed:
    - name: {{ drone_docker.lookup.paths.compose }}
    - volumes: {{ drone_docker.install.remove_all_data_for_sure }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if drone_docker.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ drone_docker.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if drone_docker.install.rootless %}
    - user: {{ drone_docker.lookup.user.name }}
{%- endif %}
    - require:
      - sls: {{ sls_config_clean }}

Drone Docker Runner compose file is absent:
  file.absent:
    - name: {{ drone_docker.lookup.paths.compose }}
    - require:
      - Drone Docker Runner is absent

Drone Docker Runner user session is not initialized at boot:
  compose.lingering_managed:
    - name: {{ drone_docker.lookup.user.name }}
    - enable: false
    - onlyif:
      - fun: user.info
        name: {{ drone_docker.lookup.user.name }}

Drone Docker Runner user account is absent:
  user.absent:
    - name: {{ drone_docker.lookup.user.name }}
    - purge: {{ drone_docker.install.remove_all_data_for_sure }}
    - require:
      - Drone Docker Runner is absent
    - retry:
        attempts: 5
        interval: 2

{%- if drone_docker.install.remove_all_data_for_sure %}

Drone Docker Runner paths are absent:
  file.absent:
    - names:
      - {{ drone_docker.lookup.paths.base }}
    - require:
      - Drone Docker Runner is absent
{%- endif %}
