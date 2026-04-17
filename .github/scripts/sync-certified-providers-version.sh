#!/bin/bash

# Copyright © 2026 SUSE LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This script is used to update all certified providers version for all docs releases.

set -e

cd $(dirname "$0")/../../versions
versions=`find ./ -maxdepth 1 -type d | grep "v." | sed "s|./||g"`

for version in $versions
do
  printf "\n### Syncing version: $version ###\n"
  url="https://raw.githubusercontent.com/rancher/turtles/refs/heads/release/$version/internal/controllers/clusterctl/config-prime.yaml"
  if ! curl --output /dev/null --silent --head --fail "$url"; then
    echo "Config not found. This version is not supported. Aborting."
    continue
  fi

  config_file=`curl https://raw.githubusercontent.com/rancher/turtles/refs/heads/release/$version/internal/controllers/clusterctl/config-prime.yaml`
  clusterctl_config=`echo "$config_file" | yq '.data["clusterctl.yaml"]'`

  antora_file_path="./$version/antora-yml/antora-product.yml"

  aws_version=`echo "$clusterctl_config" | yq '.providers[] | select(.name == "aws" and .type == "InfrastructureProvider").url' | cut -d'/' -f7`
  echo "Found CAPA version: $aws_version"
  aws_version=$aws_version yq -i '.asciidoc.attributes.aws_version=strenv(aws_version)' $antora_file_path

  azure_version=`echo "$clusterctl_config" | yq '.providers[] | select(.name == "azure" and .type == "InfrastructureProvider").url' | cut -d'/' -f7`
  echo "Found CAPZ version: $azure_version"
  azure_version=$azure_version yq -i '.asciidoc.attributes.azure_version=strenv(azure_version)' $antora_file_path

  gcp_version=`echo "$clusterctl_config" | yq '.providers[] | select(.name == "gcp" and .type == "InfrastructureProvider").url' | cut -d'/' -f7`
  echo "Found CAPG version: $gcp_version"
  gcp_version=$gcp_version yq -i '.asciidoc.attributes.gcp_version=strenv(gcp_version)' $antora_file_path

  vsphere_version=`echo "$clusterctl_config" | yq '.providers[] | select(.name == "vsphere" and .type == "InfrastructureProvider").url' | cut -d'/' -f7`
  echo "Found CAPV version: $vsphere_version"
  vsphere_version=$vsphere_version yq -i '.asciidoc.attributes.vsphere_version=strenv(vsphere_version)' $antora_file_path

  docker_version=`echo "$clusterctl_config" | yq '.providers[] | select(.name == "docker" and .type == "InfrastructureProvider").url' | cut -d'/' -f7`
  echo "Found CAPD version: $docker_version"
  docker_version=$docker_version yq -i '.asciidoc.attributes.docker_version=strenv(docker_version)' $antora_file_path

  kubeadm_version=`echo "$clusterctl_config" | yq '.providers[] | select(.name == "kubeadm" and .type == "ControlPlaneProvider").url' | cut -d'/' -f7`
  echo "Found Kubeadm version: $kubeadm_version"
  kubeadm_version=$kubeadm_version yq -i '.asciidoc.attributes.kubeadm_version=strenv(kubeadm_version)' $antora_file_path

  rke2_version=`echo "$clusterctl_config" | yq '.providers[] | select(.name == "rke2" and .type == "ControlPlaneProvider").url' | cut -d'/' -f7`
  echo "Found CAPRKE2 version: $rke2_version"
  rke2_version=$rke2_version yq -i '.asciidoc.attributes.rke2_version=strenv(rke2_version)' $antora_file_path

  fleet_addon_version=`echo "$clusterctl_config" | yq '.providers[] | select(.name == "rancher-fleet" and .type == "AddonProvider").url' | cut -d'/' -f7`
  echo "Found CAAPF version: $fleet_addon_version"
  fleet_addon_version=$fleet_addon_version yq -i '.asciidoc.attributes.fleet_addon_version=strenv(fleet_addon_version)' $antora_file_path
done
