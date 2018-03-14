cd
yum install -y git

# these avoid warning for the cherry-picks below ATM
if [ ! -f $HOME/.gitconfig ]; then
  git config --global user.email "theboss@foo.bar"
  git config --global user.name "TheBoss"
fi

git clone https://git.openstack.org/openstack/python-tripleoclient
cd python-tripleoclient

# Prepare t-h-t for undercloud in a work dir
# https://review.openstack.org/#/c/542875/
git fetch https://git.openstack.org/openstack/python-tripleoclient refs/changes/75/542875/45 && git cherry-pick FETCH_HEAD

sudo python setup.py install
cd

git clone https://git.openstack.org/openstack/tripleo-heat-templates
cd tripleo-heat-templates

# Add environments/net-noop.yaml
# https://review.openstack.org/#/c/550072/
git fetch https://git.openstack.org/openstack/tripleo-heat-templates refs/changes/72/550072/1 && git cherry-pick FETCH_HEAD

# Add EnablePuppet (defaults to true)
# https://review.openstack.org/#/c/550192/
git fetch https://git.openstack.org/openstack/tripleo-heat-templates refs/changes/92/550192/4 && git cherry-pick FETCH_HEAD

# Add DockerPuppetMountHostPuppet parameter
# https://review.openstack.org/#/c/550848/
git fetch https://git.openstack.org/openstack/tripleo-heat-templates refs/changes/48/550848/3 && git cherry-pick FETCH_HEAD

# docker-puppet.py: don't pull if image exists
# https://review.openstack.org/550959
git fetch https://git.openstack.org/openstack/tripleo-heat-templates refs/changes/59/550959/1 && git cherry-pick FETCH_HEAD

# docker: add support for TripleO UI
# https://review.openstack.org/#/c/515490/
git fetch https://git.openstack.org/openstack/tripleo-heat-templates refs/changes/90/515490/27 && git cherry-pick FETCH_HEAD

# Set TripleoUI bind_host via ServiceNetMap
# https://review.openstack.org/552879
git fetch https://git.openstack.org/openstack/tripleo-heat-templates refs/changes/79/552879/3 && git cherry-pick FETCH_HEAD
