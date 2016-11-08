==============
Oaktree Design
==============

Once 1.0.0 is released, oaktree pledges to never break backwards compatability.

Oaktree is intended to be safe for deployers to run CD from master. In fact,
a deployer running a kilo OpenStack should be able to install tip of master
of oaktree and have everything be perfectly fine.

Oaktree must be simple to install and operate. A single node install with no
shared caching or locking is likely fine for most smaller clouds. For larger
clouds, shared caching and locking are essential for scale out. Both must be
supported, and simple.

Oaktree is not pluggable.

Oaktree does not allow selectively enabling or disabling features or part of
its API.

Oaktree should be runnable by an end user pointed at a local clouds.yaml file.

Oaktree should be able to talk to other oaktrees.

Oaktree users should never need to know any information about the cloud other
than the address of the oaktree endpoint. Cloud-specific information the
user needs to know must be exposed via a capabilities API. For instance, in
order for a user to upload an image to a cloud, the user must know what format
the cloud requires the image to be in. The user must be able to ask oaktree
what image format(s) the cloud accepts.

Data returned from oaktree should be normalized such that it is consistent
no matter what drivers the cloud in question has chosen. This work is done in
shade, but shapes the design of the protobuf messages.

All objects in oaktree should have a Location. A Location defines the cloud,
the region, the zone and the project that contains the object. For objects
that exist at a region and not a zone level, like flavors and images, zone
will be null. For objects that exist at a cloud level, region will be null.
