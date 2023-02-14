# -*- coding: utf-8 -*-
# vim: ft=yaml
---
drone_docker:
  lookup:
    master: template-master
    # Just for testing purposes
    winner: lookup
    added_in_lookup: lookup_value
    compose:
      create_pod: null
      pod_args: null
      project_name: drone_docker
      remove_orphans: true
      build: false
      build_args: null
      pull: false
      service:
        container_prefix: null
        ephemeral: true
        pod_prefix: null
        restart_policy: on-failure
        restart_sec: 2
        separator: null
        stop_timeout: null
    paths:
      base: /opt/containers/drone_docker
      compose: docker-compose.yml
      config_drone_docker: drone_docker.env
      config_drone_vault: drone_vault.env
    user:
      groups: []
      home: null
      name: drone_docker
      shell: /usr/sbin/nologin
      uid: null
      gid: null
    containers:
      drone_docker:
        image: docker.io/drone/drone-runner-docker:latest
      drone_vault:
        image: docker.io/drone/drone-vault:latest
    docker_sock: null
  install:
    rootless: true
    autoupdate: true
    autoupdate_service: false
    remove_all_data_for_sure: false
  config:
    cpu:
      period: null
      quota: null
      set: null
      shares: null
    debug: null
    defer_tail_log: null
    docker:
      config: null
      network_id: null
      stream_pull: null
    env_plugin:
      endpoint: null
      skip_verify: null
      token: null
    http:
      bind: null
      host: null
      proto: null
    limit:
      events: null
      repos: null
      trusted: null
    memory:
      limit: null
      swap_limit: null
    netrc_clone_only: null
    registry_plugin:
      endpoint: null
      skip_verify: null
      token: null
    rpc:
      dump_http: null
      dump_http_body: null
      host: null
      proto: null
      secret: null
      skip_verify: null
    runner:
      capacity: null
      clone_image: null
      devices: null
      env_file: null
      environ: null
      labels: null
      max_procs: null
      name: null
      networks: null
      privileged_images: null
      secrets: null
      volumes: null
    secret_plugin:
      endpoint: null
      skip_verify: null
      token: null
    tmate:
      enabled: null
      fingerprint_ed25519: null
      fingerprint_rsa: null
      host: null
      port: null
    trace: null
    ui:
      disabled: null
      password: null
      realm: null
      username: null
  container:
    listen: 3000
  manage_podman_sock: true
  vault:
    config:
      addr: null
      approle_id: null
      approle_secret: null
      auth_mount_point: null
      auth_type: null
      cacert: null
      capath: null
      client_cert: null
      drone_debug: null
      drone_secret: null
      kubernetes_role: null
      max_retries: null
      skip_verify: null
      tls_server_name: null
      token: null
      token_renewal: null
      token_ttl: null
    enable: false

  tofs:
    # The files_switch key serves as a selector for alternative
    # directories under the formula files directory. See TOFS pattern
    # doc for more info.
    # Note: Any value not evaluated by `config.get` will be used literally.
    # This can be used to set custom paths, as many levels deep as required.
    files_switch:
      - any/path/can/be/used/here
      - id
      - roles
      - osfinger
      - os
      - os_family
    # All aspects of path/file resolution are customisable using the options below.
    # This is unnecessary in most cases; there are sensible defaults.
    # Default path: salt://< path_prefix >/< dirs.files >/< dirs.default >
    #         I.e.: salt://drone_docker/files/default
    # path_prefix: template_alt
    # dirs:
    #   files: files_alt
    #   default: default_alt
    # The entries under `source_files` are prepended to the default source files
    # given for the state
    # source_files:
    #   drone_docker-config-file-file-managed:
    #     - 'example_alt.tmpl'
    #     - 'example_alt.tmpl.jinja'

    # For testing purposes
    source_files:
      Drone Docker Runner environment file is managed:
      - drone_docker.env.j2

  # Just for testing purposes
  winner: pillar
  added_in_pillar: pillar_value
