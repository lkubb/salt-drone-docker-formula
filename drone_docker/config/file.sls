# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as drone_docker with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

Drone Docker Runner environment files are managed:
  file.managed:
    - names:
      - {{ drone_docker.lookup.paths.config_drone_docker }}:
        - source: {{ files_switch(['drone_docker.env', 'drone_docker.env.j2'],
                                  lookup='drone_docker environment file is managed',
                                  indent_width=10,
                     )
                  }}
    - mode: '0640'
    - user: root
    - group: {{ drone_docker.lookup.user.name }}
    - makedirs: True
    - template: jinja
    - require:
      - user: {{ drone_docker.lookup.user.name }}
    - watch_in:
      - Drone Docker Runner is installed
    - context:
        drone_docker: {{ drone_docker | json }}
