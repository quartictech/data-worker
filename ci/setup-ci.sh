#! /bin/bash

if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters"
fi
DESCRIPTION=${1}

# Set up Docker (see https://docs.docker.com/engine/installation/linux/debian/)
apt-get update
apt-get install -y apt-transport-https ca-certificates
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo debian-jessie main" > /etc/apt/sources.list.d/docker.list
apt-get update
apt-get install -y docker-engine
service docker start

# Install Gitlab-Runner
# (see https://gitlab.com/gitlab-org/gitlab-ci-multi-runner/blob/master/docs/install/linux-repository.md and https://docs.gitlab.com/ce/ci/docker/using_docker_build.html#use-docker-socket-binding)
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-ci-multi-runner/script.deb.sh | sudo bash
apt-get install gitlab-ci-multi-runner
gitlab-ci-multi-runner register -n \
  --url https://gitlab.com/ci \
  --registration-token pX8B2xgx6AKFteBeaRFE \
  --executor docker \
  --description "${DESCRIPTION}" \
  --docker-image "docker:latest" \
  --docker-volumes /var/run/docker.sock:/var/run/docker.sock
