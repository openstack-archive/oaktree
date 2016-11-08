===========
Work Needed
===========

Design the auth story
---------------------

The native/default auth for gRPC is oauth. It has the ability for pluggable
auth, but that would raise the barrier for new languages. I'd love it if we
can come up with a story that involves making API users in keystone and
authorizing them to use oaktree via an oauth transaction. The keystone auth
backends currently are all about integrating with other auth management
systems, which is great for environments where you have a web browser, but not
so much for ones where you need to put your auth credentials into a file so
that your scripts can work. I'm waving my hands wildly here - because all I
really have are problems to solve and none of the solutions I have are great.

Design Glance Image / Swift Object Uploads and Downloads
--------------------------------------------------------

Having those two data operations go through an API proxy seems inefficient.
However, having them not in the API seems like a bad user experience. Perhaps
if we take advantage of the gRPC streaming protocol support doing a direct
streaming passthrough actually wouldn't be awful. Or maybe the better approach
would be for the gRPC call to return a URL and token for a user to POST/PUT to
directly. Literally no clue.

Design and implement Capabilities API
-------------------------------------

shade and the current oaktree codebase rely on os-client-config and clouds.yaml
for information about the cloud and what it can do. As a service, some of the
pieces of information in os-client-config need to be queriable by the user.

Implement API surfaces
----------------------

In general, all of the API operations shade can perform should be exposed in
oaktree. In order to shape that work, we should tackle them in the following
order:

#. API surface needed for nodepool
#. API surface needed for existing Ansible modules
#. Everything else

Implement oaktree backend in shade
----------------------------------

It's turtles all the way down. If shade sees that a cloud has an oaktree
service, shade should talk to it over gRPC instead of talking to the REST
APIs directly.
