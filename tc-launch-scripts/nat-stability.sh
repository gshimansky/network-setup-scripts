export NFF_GO_IMAGE_PREFIX=tcstability
export PATH=/opt/go/bin:"$PATH"
export GOROOT=/opt/go
export GOPATH=%teamcity.agent.work.dir%
export no_proxy='antsatel01,antsatel04.an.intel.com,antsatel05.an.intel.com,antsatel06.an.intel.com,github.intel.com'
export http_proxy=http://fmproxyslb.ice.intel.com:911
export ftp_proxy=http://fmproxyslb.ice.intel.com:911
export https_proxy=http://fmproxyslb.ice.intel.com:911
export HTTP_PROXY=$http_proxy
export HTTPS_PROXY=$https_proxy
export VM_NAME=tctestvms
export VM_TOTAL_NUMBER=3

$(cd /localdisk/tc_agent/vagrant; ./getports.sh 22)
echo MACHINE 0
ssh vagrant@localhost -p $sp0 -o LogLevel=FATAL -o Compression=yes -o DSAAuthentication=yes -o IdentitiesOnly=yes -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o IdentityFile="/localdisk/tc_agent/vagrant/.vagrant/machines/tctestvms-0/virtualbox/private_key" sudo -E ./network-setup-scripts/reconfigure.sh ./network-setup-scripts/vm/nat/client.sh
echo MACHINE 1
ssh vagrant@localhost -p $sp1 -o LogLevel=FATAL -o Compression=yes -o DSAAuthentication=yes -o IdentitiesOnly=yes -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o IdentityFile="/localdisk/tc_agent/vagrant/.vagrant/machines/tctestvms-1/virtualbox/private_key" sudo -E ./network-setup-scripts/reconfigure.sh ./network-setup-scripts/vm/dpdk/0809.sh
echo MACHINE 2
ssh vagrant@localhost -p $sp2 -o LogLevel=FATAL -o Compression=yes -o DSAAuthentication=yes -o IdentitiesOnly=yes -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o IdentityFile="/localdisk/tc_agent/vagrant/.vagrant/machines/tctestvms-2/virtualbox/private_key" sudo -E ./network-setup-scripts/reconfigure.sh ./network-setup-scripts/vm/nat/server.sh

$(cd /localdisk/tc_agent/vagrant; ./getports.sh 2375)
cd test/framework/main
./tf -directory nat-stabilityresults -config stability-nat.json -hosts $NFF_GO_HOSTS
