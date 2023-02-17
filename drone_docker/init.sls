# vim: ft=sls

{#-
    *Meta-state*.

    This installs the drone_docker, drone_vault containers,
    manages their configuration and starts their services.
#}

include:
  - .package
  - .config
  - .service
