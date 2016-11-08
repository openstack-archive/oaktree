==========================
Frequently Asked Questions
==========================

Why gRPC and not REST?
----------------------

There are three main reasons.

We already have REST APIs. oaktree is not intended to replace them, but to
supplement them to grease the 80% case that can be inter-operable.

gRPC comes out of the gate with direct support for a pile of languages, so
supporting our non-Python friends is direct and straightforward.

A TON of time is spent in shade polling OpenStack for results. That may not
sound like a problem - but when you spin up thousands of VMs a day like Infra
does, the polling becomes a major engineering challenge. gRPC operates over
http/2 and has support for bi-directional channels - which means you can just
have a function notify you when something is done. That's a win for everyone

Why write it in Python rather than XXX?
---------------------------------------

The hard part of this isn't the gRPC api - it's the business logic that's in
the shade library. If we wrote oaktree from scratch in C++ (because hello
super-high-performance gRPC backend!) - we'd be faced with the task of
re-implementing all of the shade business logic in C++. If you haven't looked,
there is a LOT.

shade is what infra uses for nodepool. It has copious features in it already
to deal with extremely high scale - including configurable caching, batched
list update operations to prevent thundering herds and well exercised
multi-threaded support.

The interesting part also isn't the server (it's a simple proxy layer) - it's
the clients. THOSE definitely want much love in the different languages. The
infrastructure is in place for Python, C++ and Go. Ruby, javascript and C#
should follow asap.

Can I add support for my project?
---------------------------------

Yes. It has to be added to shade first, which accepts patches from anything
that can be tested consistently in a devstack job. We require all new features
in shade to come with functional tests. Once it's in shade, it can be added as
an API to oaktree.

However ... oaktree and shade both promise 100% backwards compatibility at all
times. If your project is still young, be aware that once an API is added to
shade or oaktree it will need to be supported until the end of time.
