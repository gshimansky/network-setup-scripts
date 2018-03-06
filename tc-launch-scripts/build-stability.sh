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

dp0=2200
dp1=2201
dp2=2203
export NFF_GO_HOSTS=localhost:$dp0,localhost:$dp1,localhost:$dp2
make -j16 cleanall
make -j16 deploy
