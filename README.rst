=======
oaktree
=======

Make your cloud throw some shade

oaktree is a gRPC interface for interacting with OpenStack clouds that is
inherently interoperable and multi-cloud aware. It is based on the python
shade library, which grew all of the logic needed to interact with OpenStack
clouds and to work around differences in vendor deployment choices. Rather
than keep all of that love in Python Library form, oaktree allows other
languages to reap the benefits as well.

oaktree is not a replacement for all of the individual project REST APIs.
Those are all essential for cross-project communication and are well suited
for operators who can be expected to know things about how they have
deployed their clouds - and who in fact WANT to be able to make changes in
the cloud knowing deployment specifics. oaktree will never be for them.

oaktree is for end-users who do not and should not know what hypervisor, what
storage driver or what network stack the deployer has chosen. The two sets
of people are different audiences, so oaktree is a project to support the
end user.

Using
-----

Install oaktreemodel by hand. Then:

In one window:

.. code-block:: bash

  python oaktree/server.py

oaktree/server.py assumes you have a clouds.yaml accessible.

In another window:

.. code-block:: bash

  python -i devstack/test.py

You'll have an images and a flavors object you can poke at.

If you want to operate against a different cloud than `devstack`, you can
pass it to devstack/test.py as the first command line argument.

Shape of the Project
--------------------

oaktree should be super simple to deploy, and completely safe for deployers
to upgrade from master constantly. Once it's released as a 1.0, it should
NEVER EVER EVER EVER EVER EVER EVER have a backwards incompatible change.
There is no reason, no justification, no obsession important enough to
inflict such pain on the user.

The shade library will grow the ability to detect if a cloud has an oaktree
api available, and if it does, it will use it. Hopefully we'll quickly reach
a point where all deployers are deploying oaktree.

* Documentation: http://docs.openstack.org/developer/oaktree
* Source: http://git.openstack.org/cgit/openstack/oaktree
* Bugs: http://bugs.launchpad.net/oaktree
