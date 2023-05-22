# vim: ft=sls

{#-
    Removes the configuration of the drone_docker, drone_vault containers
    and has a dependency on `drone_docker.service.clean`_.

    This does not lead to the containers/services being rebuilt
    and thus differs from the usual behavior.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_service_clean = tplroot ~ ".service.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as drone_docker with context %}

include:
  - {{ sls_service_clean }}

Drone Docker Runner environment files are absent:
  file.absent:
    - names:
      - {{ drone_docker.lookup.paths.config_drone_docker }}
      - {{ drone_docker.lookup.paths.config_drone_vault }}
      - {{ drone_docker.lookup.paths.base | path_join("tls", "ca.pem") }}
    - require:
      - sls: {{ sls_service_clean }}
