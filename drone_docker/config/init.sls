# vim: ft=sls

{#-
    Manages the configuration of the drone_docker, drone_vault containers.
    Has a dependency on `drone_docker.package`_.
#}

include:
  - .file
