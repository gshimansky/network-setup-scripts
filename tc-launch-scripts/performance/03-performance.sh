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

echo MACHINE 0
ssh antsatel04.an.intel.com sudo -E /localdisk/gashiman/network-setup-scripts/reconfigure.sh /localdisk/gashiman/network-setup-scripts/an/dpdk/all.sh
echo MACHINE 1
ssh antsatel05.an.intel.com sudo -E /localdisk/gashiman/network-setup-scripts/reconfigure.sh /localdisk/gashiman/network-setup-scripts/an/dpdk/all.sh
echo MACHINE 2
ssh antsatel06.an.intel.com sudo -E /localdisk/gashiman/network-setup-scripts/reconfigure.sh /localdisk/gashiman/network-setup-scripts/an/dpdk/all.sh

export NFF_GO_HOSTS=antsatel06.an.intel.com:2375,antsatel05.an.intel.com:2375,antsatel04.an.intel.com:2375
cd test/framework/main
./tf -directory perfresults -var INPORT1=1 -var OUTPORT1_1=1 -var OUTPORT1_2=1 -var PKTGENPORT=[1:2-3].0 -config perf.json -hosts $NFF_GO_HOSTS
