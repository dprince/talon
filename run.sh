#TEMPLATES=/usr/share/openstack-tripleo-heat-templates/
set -x
TEMPLATES=/root/tripleo-heat-templates/

mkdir /tmp/root

docker run --volume /tmp/root:/root/ tripleoclient:custom /usr/bin/openstack overcloud container image prepare \
--tag tripleo-ci-testing \
--namespace trunk.registry.rdoproject.org/master \
--output-env-file=/root/containers.yaml \
--template-file /usr/share/tripleo-common/container-images/overcloud_containers.yaml.j2 \
-r $TEMPLATES/roles_data_undercloud.yaml

sudo bash <<EOF_BASH
cat >> /tmp/root/containers.yaml <<EOF_CAT
  DockerTripleoUIImage: trunk.registry.rdoproject.org/master/centos-binary-tripleo-ui:tripleo-ci-testing
  DockerTripleoUIConfigImage: trunk.registry.rdoproject.org/master/centos-binary-tripleo-ui:tripleo-ci-testing
  DockerPuppetMountHostPuppet: false
  EnablePuppet: false
EOF_CAT
EOF_BASH

set -e
time docker run --net=host --privileged --volume /tmp/root/:/root/tmp/ tripleoclient:custom /usr/bin/openstack undercloud deploy \
--local-ip=172.30.0.1 \
--templates=$TEMPLATES \
--output-only \
--output-dir=/root/tmp/ \
-e /root/tmp/containers.yaml \
-e $TEMPLATES/environments/docker.yaml \
-e $TEMPLATES/environments/net-noop.yaml \
-e $TEMPLATES/environments/services-docker/tripleo-ui.yaml \
-e $TEMPLATES/environments/config-download-environment.yaml \
-r $TEMPLATES/roles_data_undercloud.yaml
set +e

TMPDIR=$(ls -ltr /tmp/root | grep "tripleo-.*-config" | awk '{print $9}' | tail -n 1)

sudo bash <<EOF_BASH
pushd /tmp/root/$TMPDIR
ln -s /home/dprince/projects/tripleo/tripleo-common/roles/ .
time sudo ansible-playbook -i inventory.yaml deploy_steps_playbook.yaml -e role_name=Undercloud -e deploy_server_id=undercloud -e bootstrap_server_id=undercloud -e docker_puppet_mount_host_puppet=false -e enable_puppet=false
EOF_BASH
