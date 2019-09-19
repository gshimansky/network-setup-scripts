export NFF_GO_IMAGE_PREFIX=tcstability
export PATH=/opt/go/bin:"$PATH"
export GOROOT=/opt/go
export NFF_GO=$(pwd)/nff-go
export no_proxy='antsatel01,antsatel04.an.intel.com,antsatel05.an.intel.com,antsatel06.an.intel.com,github.intel.com'
export http_proxy=http://fmproxyslb.ice.intel.com:911
export ftp_proxy=http://fmproxyslb.ice.intel.com:911
export https_proxy=http://fmproxyslb.ice.intel.com:911
export HTTP_PROXY=$http_proxy
export HTTPS_PROXY=$https_proxy
export VM_NAME=tctestvms
export VM_TOTAL_NUMBER=3

(cd /localdisk/tc_agent/vagrant; vagrant reload)
$(cd /localdisk/tc_agent/vagrant; ./getports.sh 2375)
rc=$?
if [ $rc != 0 ]; then exit 1; fi

. ./env.sh
go mod download
make -j16 cleanall
make -j16
make -j1 deploy
