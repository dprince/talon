#FROM 172.19.0.2:8787/master/centos-binary-base:tripleo-ci-testing
FROM trunk.registry.rdoproject.org/master/centos-binary-base:tripleo-ci-testing
LABEL maintainer="dprince" name="tripleoclient"

# setup repos
COPY tripleo_repos.sh /usr/local/bin/tripleo_repos.sh
RUN bash /usr/local/bin/tripleo_repos.sh

RUN yum install -y python-ipaddr python-openstackclient python-tripleoclient puppet-tripleo openstack-tripleo-validations e2fsprogs xfsprogs openssh-clients vim-enhanced git openstack-heat-monolith

# tripleoclient
COPY tripleoclient.sh /usr/local/bin/tripleoclient.sh
RUN bash /usr/local/bin/tripleoclient.sh

#RUN yum install -y centos-release-openshift-origin37
#RUN yum install -y openshift-ansible-playbooks

#RUN cd /usr/share/ansible/openshift-ansible/playbooks/byo; curl https://github.com/jistr/openshift-ansible/commit/6bfccd0cee5332db46c704977a4e8a15f4c4944c.patch | patch -p1

COPY create_super_user.sh /usr/local/bin/create_super_user.sh
RUN chmod 750 /usr/local/bin/create_super_user.sh

RUN sed -i /usr/lib/python2.7/site-packages/tripleo_common/image/image_uploader.py -e "s|self.secure_registries.*set.*|self.secure_registries = set(SECURE_REGISTRIES)|"

USER root
CMD /usr/local/bin/create_super_user.sh
