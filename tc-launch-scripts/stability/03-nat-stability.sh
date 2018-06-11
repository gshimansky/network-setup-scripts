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
rc=$?
if [ $rc != 0 ]; then exit 1; fi

echo MACHINE 0
ssh -F $sc0 tctestvms-0 sudo -E ./network-setup-scripts/reconfigure.sh ./network-setup-scripts/lv/virtio/nat/client.sh
echo MACHINE 1
ssh -F $sc1 tctestvms-1 sudo -E ./network-setup-scripts/reconfigure.sh ./network-setup-scripts/lv/virtio/nat/middle.sh
echo MACHINE 2
ssh -F $sc2 tctestvms-2 sudo -E ./network-setup-scripts/reconfigure.sh ./network-setup-scripts/lv/virtio/nat/server.sh

$(cd /localdisk/tc_agent/vagrant; ./getports.sh 2375)
cd test/framework/main
./tf -directory nat-stabilityresults -config nat/stability-nat.json -hosts $NFF_GO_HOSTS
