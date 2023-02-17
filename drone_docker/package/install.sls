# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as drone_docker with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

Drone Docker Runner user account is present:
  user.present:
{%- for param, val in drone_docker.lookup.user.items() %}
{%-   if val is not none and param != "groups" %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
    - usergroup: true
    - createhome: true
    - groups: {{ drone_docker.lookup.user.groups | json }}
    # (on Debian 11) subuid/subgid are only added automatically for non-system users
    - system: false

Drone Docker Runner user session is initialized at boot:
  compose.lingering_managed:
    - name: {{ drone_docker.lookup.user.name }}
    - enable: {{ drone_docker.install.rootless }}
    - require:
      - user: {{ drone_docker.lookup.user.name }}

Drone Docker Runner paths are present:
  file.directory:
    - names:
      - {{ drone_docker.lookup.paths.base }}
    - user: {{ drone_docker.lookup.user.name }}
    - group: {{ drone_docker.lookup.user.name }}
    - makedirs: true
    - require:
      - user: {{ drone_docker.lookup.user.name }}

{%- if drone_docker.install.podman_api %}

Drone Docker Runner podman API is enabled:
  compose.systemd_service_enabled:
    - name: podman
    - user: {{ drone_docker.lookup.user.name }}
    - require:
      - Drone Docker Runner user session is initialized at boot

Drone Docker Runner podman API is available:
  compose.systemd_service_running:
    - name: podman
    - user: {{ drone_docker.lookup.user.name }}
    - require:
      - Drone Docker Runner user session is initialized at boot
{%- endif %}

Drone Docker Runner compose file is managed:
  file.managed:
    - name: {{ drone_docker.lookup.paths.compose }}
    - source: {{ files_switch(["docker-compose.yml", "docker-compose.yml.j2"],
                              lookup="Drone Docker Runner compose file is present"
                 )
              }}
    - mode: '0644'
    - user: root
    - group: {{ drone_docker.lookup.rootgroup }}
    - makedirs: True
    - template: jinja
    - makedirs: true
    - context:
        drone_docker: {{ drone_docker | json }}

{%- if drone_docker.manage_podman_sock %}

Podman API socket is enabled:
  compose.systemd_service_enabled:
    - name: podman.socket
{%-   if drone_docker.install.rootless %}
    - user: {{ drone_docker.lookup.user.name }}
{%-   endif %}

Podman API socket is available now:
  compose.systemd_service_running:
    - name: podman.socket
{%-   if drone_docker.install.rootless %}
    - user: {{ drone_docker.lookup.user.name }}
{%-   endif %}
{%- endif %}

Drone Docker Runner is installed:
  compose.installed:
    - name: {{ drone_docker.lookup.paths.compose }}
{%- for param, val in drone_docker.lookup.compose.items() %}
{%-   if val is not none and param != "service" %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
{%- for param, val in drone_docker.lookup.compose.service.items() %}
{%-   if val is not none %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
    - watch:
      - file: {{ drone_docker.lookup.paths.compose }}
{%- if drone_docker.install.rootless %}
    - user: {{ drone_docker.lookup.user.name }}
    - require:
      - user: {{ drone_docker.lookup.user.name }}
{%- endif %}

{%- if drone_docker.install.autoupdate_service is not none %}

Podman autoupdate service is managed for Drone Docker Runner:
{%-   if drone_docker.install.rootless %}
  compose.systemd_service_{{ "enabled" if drone_docker.install.autoupdate_service else "disabled" }}:
    - user: {{ drone_docker.lookup.user.name }}
{%-   else %}
  service.{{ "enabled" if drone_docker.install.autoupdate_service else "disabled" }}:
{%-   endif %}
    - name: podman-auto-update.timer
{%- endif %}
