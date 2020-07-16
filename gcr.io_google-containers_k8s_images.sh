#!/bin/bash

set -e
#https://console.cloud.google.com/gcr/images/google-containers/GLOBAL?project=google-containers
KUBE_VERSION=v1.18.5
KUBE_PAUSE_VERSION=3.2
ETCD_VERSION=3.4.9
CORE_DNS_VERSION=1.7.0

GCR_URL=gcr.io

images=(kube-proxy:${KUBE_VERSION}
kube-scheduler:${KUBE_VERSION}
kube-controller-manager:${KUBE_VERSION}
kube-apiserver:${KUBE_VERSION}
pause:${KUBE_PAUSE_VERSION}
pause-amd64:${KUBE_PAUSE_VERSION}
etcd:${ETCD_VERSION}
coredns:${CORE_DNS_VERSION})

for imageName in ${images[@]} ; do
  Name=$(echo $imageName|awk -F":" '{print $1}')
  Version=$(echo $imageName|awk -F":" '{print $2}')
  test -d ${Name}/${Version} || mkdir -p ${Name}/${Version}
  cat >${Name}/${Version}/Dockerfile << EOF
FROM ${GCR_URL}/google-containers/${imageName}
MAINTAINER hjl369 <github.com/hjl369>
EOF
done


