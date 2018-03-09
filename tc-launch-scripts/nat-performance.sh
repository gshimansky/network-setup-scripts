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
ssh antsatel04.an.intel.com sudo -E /localdisk/gashiman/network-setup-scripts/reconfigure.sh /localdisk/gashiman/network-setup-scripts/an/nat/antsatel04_client_40g.sh
echo MACHINE 1
ssh antsatel05.an.intel.com sudo -E /localdisk/gashiman/network-setup-scripts/reconfigure.sh /localdisk/gashiman/network-setup-scripts/an/dpdk/40g.sh
echo MACHINE 2
ssh antsatel06.an.intel.com sudo -E /localdisk/gashiman/network-setup-scripts/reconfigure.sh /localdisk/gashiman/network-setup-scripts/an/nat/antsatel06_server_40g.sh

export NFF_GO_HOSTS=antsatel04.an.intel.com:2375,antsatel05.an.intel.com:2375,antsatel06.an.intel.com:2375
cd test/framework/main
./tf -directory nat-perfresults -config perf-nat.json -hosts $NFF_GO_HOSTS
