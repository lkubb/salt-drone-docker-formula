Available states
----------------

The following states are found in this formula:

.. contents::
   :local:


``drone_docker``
^^^^^^^^^^^^^^^^
*Meta-state*.

This installs the drone_docker, drone_vault containers,
manages their configuration and starts their services.


``drone_docker.package``
^^^^^^^^^^^^^^^^^^^^^^^^
Installs the drone_docker, drone_vault containers only.
This includes creating systemd service units.


``drone_docker.config``
^^^^^^^^^^^^^^^^^^^^^^^
Manages the configuration of the drone_docker, drone_vault containers.
Has a dependency on `drone_docker.package`_.


``drone_docker.service``
^^^^^^^^^^^^^^^^^^^^^^^^
Starts the drone_docker, drone_vault container services
and enables them at boot time.
Has a dependency on `drone_docker.config`_.


``drone_docker.clean``
^^^^^^^^^^^^^^^^^^^^^^
*Meta-state*.

Undoes everything performed in the ``drone_docker`` meta-state
in reverse order, i.e. stops the drone_docker, drone_vault services,
removes their configuration and then removes their containers.


``drone_docker.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Removes the drone_docker, drone_vault containers
and the corresponding user account and service units.
Has a depency on `drone_docker.config.clean`_.
If ``remove_all_data_for_sure`` was set, also removes all data.


``drone_docker.config.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Removes the configuration of the drone_docker, drone_vault containers
and has a dependency on `drone_docker.service.clean`_.

This does not lead to the containers/services being rebuilt
and thus differs from the usual behavior.


``drone_docker.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Stops the drone_docker, drone_vault container services
and disables them at boot time.


