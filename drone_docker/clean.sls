# vim: ft=sls

{#-
    *Meta-state*.

    Undoes everything performed in the ``drone_docker`` meta-state
    in reverse order, i.e. stops the drone_docker, drone_vault services,
    removes their configuration and then removes their containers.
#}

include:
  - .service.clean
  - .config.clean
  - .package.clean
