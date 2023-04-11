# vim: ft=sls

{#-
    Removes the drone_docker, drone_vault containers
    and the corresponding user account and service units.
    Has a depency on `drone_docker.config.clean`_.
    If ``remove_all_data_for_sure`` was set, also removes all data.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_clean = tplroot ~ ".config.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as drone_docker with context %}

include:
  - {{ sls_config_clean }}

{%- if drone_docker.install.autoupdate_service %}

Podman autoupdate service is disabled for Drone Docker Runner:
{%-   if drone_docker.install.rootless %}
  compose.systemd_service_disabled:
    - user: {{ drone_docker.lookup.user.name }}
{%-   else %}
  service.disabled:
{%-   endif %}
    - name: podman-auto-update.timer
{%- endif %}

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

{%- if drone_docker.install.podman_api %}

Drone Docker Runner podman API is unavailable:
  compose.systemd_service_dead:
    - name: podman.socket
    - user: {{ drone_docker.lookup.user.name }}
    - onlyif:
      - fun: user.info
        name: {{ drone_docker.lookup.user.name }}

Drone Docker Runner podman API is disabled:
  compose.systemd_service_disabled:
    - name: podman.socket
    - user: {{ drone_docker.lookup.user.name }}
    - onlyif:
      - fun: user.info
        name: {{ drone_docker.lookup.user.name }}
{%- endif %}

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
