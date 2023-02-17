# vim: ft=sls

{#-
    Starts the drone_docker, drone_vault container services
    and enables them at boot time.
    Has a dependency on `drone_docker.config`_.
#}

include:
  - .running
