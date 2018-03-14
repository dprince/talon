cd
yum install -y git
git clone https://git.openstack.org/openstack/tripleo-repos
cd tripleo-repos
sudo python setup.py install
cd
#sudo tripleo-repos current-tripleo
sudo tripleo-repos current
rm -Rf tripleo-repos
sudo yum update -y
