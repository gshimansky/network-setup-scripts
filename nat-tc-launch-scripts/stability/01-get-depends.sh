go get -v golang.org/x/tools/cmd/stringer
(cd nff-go/test/framework; go generate)
(cd nff-go/test/framework/main; go build tf.go)

make -j16 -C nff-go/dpdk all
