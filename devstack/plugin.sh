#!/bin/bash
#
# Copyright 2016 Red Hat, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

# Install shade from git if requested. If not requested
# oaktree install will pull it in.
function install_shade {
    if use_library_from_git "shade"; then
        GITREPO["shade"]=$SHADE_REPO_URL
        GITDIR["shade"]=$DEST/shade
        GITBRANCH["shade"]=$SHADE_REPO_REF
        git_clone_by_name "shade"
        # Install shade globally, because the job config has LIBS_FROM_GIT
        # and if we don't install it globally, all hell breaks loose
        setup_dev_lib "shade"
    fi
}

function install_oaktreemodel {
    if use_library_from_git "oaktreemodel"; then
        GITREPO["oaktreemodel"]=$OAKTREEMODEL_REPO_URL
        GITDIR["oaktreemodel"]=$DEST/oaktreemodel
        GITBRANCH["oaktreemodel"]=$OAKTREEMODEL_REPO_REF
        git_clone_by_name "oaktreemodel"
        pushd $DEST/oaktreemodel
        /usr/local/jenkins/slave_scripts/install-distro-packages.sh
        export GOPATH=$DEST/gopath
        mkdir $GOPATH
        export PATH=$GOPATH/bin:$PATH
        go get -u github.com/golang/protobuf/protoc-gen-go
        sudo pip install grpcio grpcio-tools
        ./bootstrap.sh
        ./configure
        make
        pip install -e .
        popd
    fi
}

# Install oaktree code
function install_oaktree {
    # TODO(mordred) remove these comments when project-config job is fixed
    #if use_library_from_git "oaktree"; then
    GITREPO["oaktree"]=$OAKTREE_REPO_URL
    GITDIR["oaktree"]=$DEST/oaktree
    GITBRANCH["oaktree"]=$OAKTREE_REPO_REF
    git_clone_by_name "oaktree"
    setup_dev_lib "oaktree"
    #fi
}

function configure_oaktree {
    :
}

function start_oaktree {

    if is_service_enabled statsd; then
        # run a fake statsd so we test stats sending paths
        export STATSD_HOST=localhost
        export STATSD_PORT=8125
        run_process statsd "socat -u udp-recv:$STATSD_PORT -"
    fi

    run_process oaktree "python -m oaktree.server"
    :
}

function shutdown_oaktree {
    stop_process oaktree
    :
}

function cleanup_oaktree {
    :
}

# check for service enabled
if is_service_enabled oaktree; then

    if [[ "$1" == "stack" && "$2" == "install" ]]; then
        # Perform installation of service source
        echo_summary "Installing oaktree"
        install_shade
        install_oaktreemodel
        install_oaktree

    elif [[ "$1" == "stack" && "$2" == "post-config" ]]; then
        # Configure after the other layer 1 and 2 services have been configured
        echo_summary "Configuring oaktree"
        configure_oaktree

    elif [[ "$1" == "stack" && "$2" == "extra" ]]; then
        # Initialize and start the oaktree service
        echo_summary "Initializing oaktree"
        start_oaktree
    fi

    if [[ "$1" == "unstack" ]]; then
        # Shut down oaktree services
        # no-op
        shutdown_oaktree
    fi

    if [[ "$1" == "clean" ]]; then
        # Remove state and transient data
        # Remember clean.sh first calls unstack.sh
        # no-op
        cleanup_oaktree
    fi
fi
