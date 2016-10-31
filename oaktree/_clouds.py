# Copyright (c) 2016 Red Hat, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import shade

all_clouds = {}


def _make_cloud_key(cloud, region, domain, project):
    return "{cloud}:{region}:{domain}:{project}".format(
        cloud=cloud, region=region, domain=domain, project=project)


def _get_cloud(cloud, region, project=None):
    if project:
        domain_id = project.domain_id
        domain_name = project.domain_name
        project_id = project.id
        project_name = project.name
        kwargs = dict(
            project_domain_id=domain_id,
            project_domain_name=domain_name,
            project_id=project_id,
            project_name=project_name,
        )
    else:
        domain_id = domain_name = project_id = project_name = None
        kwargs = {}

    key = _make_cloud_key(
        cloud, region,
        domain_id or domain_name,
        project_id or project_name
    )
    if key not in all_clouds:
        all_clouds[key] = shade.openstack_cloud(
            cloud=cloud, region_name=region,
            debug=True, strict=True, **kwargs)
    return all_clouds[key]
