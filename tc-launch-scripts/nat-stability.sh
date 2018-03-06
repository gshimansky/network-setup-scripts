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

sp0=2222
sp1=2202
sp2=2204
echo MACHINE 0
ssh vagrant@localhost -p $sp0 -o LogLevel=FATAL -o Compression=yes -o DSAAuthentication=yes -o IdentitiesOnly=yes -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o IdentityFile="/localdisk/tc_agent/vagrant/.vagrant/machines/tctestvms-0/virtualbox/private_key" sudo -E ./network-setup-scripts/reconfigure.sh ./network-setup-scripts/vm/nat/client.sh
echo MACHINE 1
ssh vagrant@localhost -p $sp1 -o LogLevel=FATAL -o Compression=yes -o DSAAuthentication=yes -o IdentitiesOnly=yes -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o IdentityFile="/localdisk/tc_agent/vagrant/.vagrant/machines/tctestvms-1/virtualbox/private_key" sudo -E ./network-setup-scripts/reconfigure.sh ./network-setup-scripts/vm/nat/middle.sh
echo MACHINE 2
ssh vagrant@localhost -p $sp2 -o LogLevel=FATAL -o Compression=yes -o DSAAuthentication=yes -o IdentitiesOnly=yes -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o IdentityFile="/localdisk/tc_agent/vagrant/.vagrant/machines/tctestvms-2/virtualbox/private_key" sudo -E ./network-setup-scripts/reconfigure.sh ./network-setup-scripts/vm/nat/server.sh

dp0=2200
dp1=2201
dp2=2203
export NFF_GO_HOSTS=localhost:$dp0,localhost:$dp1,localhost:$dp2
cd test/framework/main
./tf -config stability-nat.json -hosts $NFF_GO_HOSTS
