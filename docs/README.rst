.. _readme:

Drone Docker Runner Formula
===========================

|img_sr| |img_pc|

.. |img_sr| image:: https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg
   :alt: Semantic Release
   :scale: 100%
   :target: https://github.com/semantic-release/semantic-release
.. |img_pc| image:: https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white
   :alt: pre-commit
   :scale: 100%
   :target: https://github.com/pre-commit/pre-commit

Manage Drone Docker Runner with Salt and Podman.

.. contents:: **Table of Contents**
   :depth: 1

General notes
-------------

See the full `SaltStack Formulas installation and usage instructions
<https://docs.saltproject.io/en/latest/topics/development/conventions/formulas.html>`_.

If you are interested in writing or contributing to formulas, please pay attention to the `Writing Formula Section
<https://docs.saltproject.io/en/latest/topics/development/conventions/formulas.html#writing-formulas>`_.

If you want to use this formula, please pay attention to the ``FORMULA`` file and/or ``git tag``,
which contains the currently released version. This formula is versioned according to `Semantic Versioning <http://semver.org/>`_.

See `Formula Versioning Section <https://docs.saltproject.io/en/latest/topics/development/conventions/formulas.html#versioning>`_ for more details.

If you need (non-default) configuration, please refer to:

- `how to configure the formula with map.jinja <map.jinja.rst>`_
- the ``pillar.example`` file
- the `Special notes`_ section

Special notes
-------------
* This formula is written with the custom `compose modules <https://github.com/lkubb/salt-podman-formula>`_ in mind and will not work without them.

Configuration
-------------
An example pillar is provided, please see `pillar.example`. Note that you do not need to specify everything by pillar. Often, it's much easier and less resource-heavy to use the ``parameters/<grain>/<value>.yaml`` files for non-sensitive settings. The underlying logic is explained in `map.jinja`.


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



Contributing to this repo
-------------------------

Commit messages
^^^^^^^^^^^^^^^

**Commit message formatting is significant!**

Please see `How to contribute <https://github.com/saltstack-formulas/.github/blob/master/CONTRIBUTING.rst>`_ for more details.

pre-commit
^^^^^^^^^^

`pre-commit <https://pre-commit.com/>`_ is configured for this formula, which you may optionally use to ease the steps involved in submitting your changes.
First install  the ``pre-commit`` package manager using the appropriate `method <https://pre-commit.com/#installation>`_, then run ``bin/install-hooks`` and
now ``pre-commit`` will run automatically on each ``git commit``. ::

  $ bin/install-hooks
  pre-commit installed at .git/hooks/pre-commit
  pre-commit installed at .git/hooks/commit-msg

State documentation
~~~~~~~~~~~~~~~~~~~
There is a script that semi-autodocuments available states: ``bin/slsdoc``.

If a ``.sls`` file begins with a Jinja comment, it will dump that into the docs. It can be configured differently depending on the formula. See the script source code for details currently.

This means if you feel a state should be documented, make sure to write a comment explaining it.
