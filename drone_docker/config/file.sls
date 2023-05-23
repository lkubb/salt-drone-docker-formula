# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_package_install = tplroot ~ ".package.install" %}
{%- from tplroot ~ "/map.jinja" import mapdata as drone_docker with context %}
{%- from tplroot ~ "/libtofsstack.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

Drone Docker Runner environment files are managed:
  file.managed:
    - names:
      - {{ drone_docker.lookup.paths.config_drone_docker }}:
        - source: {{ files_switch(
                        ["drone_docker.env", "drone_docker.env.j2"],
                        config=drone_docker,
                        lookup="drone_docker environment file is managed",
                        indent_width=10,
                     )
                  }}
{%- if drone_docker.vault.enable %}
      - {{ drone_docker.lookup.paths.config_drone_vault }}:
        - source: {{ files_switch(
                        ["drone_vault.env", "drone_vault.env.j2"],
                        config=drone_docker,
                        lookup="drone_vault environment file is managed",
                        indent_width=10,
                     )
                  }}
{%-   if drone_docker.vault.config.cacert %}
      - {{ drone_docker.lookup.paths.base | path_join("tls", "ca.pem") }}:
        - contents: {{ salt["x509.encode_certificate"](drone_docker.vault.config.cacert) | json }}
        - mode: '0644'
{%-   endif %}
{%- endif %}
    - mode: '0640'
    - user: root
    - group: {{ drone_docker.lookup.user.name }}
    - makedirs: true
    - template: jinja
    - require:
      - user: {{ drone_docker.lookup.user.name }}
    - watch_in:
      - Drone Docker Runner is installed
    - context:
        drone_docker: {{ drone_docker | json }}
