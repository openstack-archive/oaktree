# flake8: noqa
import sys

import grpc

from oaktreemodel import model
from oaktreemodel import oaktree_pb2

channel = grpc.insecure_channel('localhost:50051')
stub = oaktree_pb2.OaktreeStub(channel)

cloud = model.Location()
if len(sys.argv) > 1:
    cloud.cloud = sys.argv[1]
else:
    cloud.cloud = 'devstack'

flavors = stub.SearchFlavors(model.Filter(location=cloud))
print flavors
images = stub.SearchImages(model.Filter(location=cloud))
print images
