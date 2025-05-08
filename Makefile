include ./Makefile.Common

.PHONY: gen-protobuf
gen-protobuf: install-protoc
	$(PROTOC_BIN) --go_out=. --go_opt=paths=source_relative \
    	--go-grpc_out=. --go-grpc_opt=paths=source_relative \
    	./pkg/cni/api/v1alpha1/cni.proto

.PHONY: gen-vppbinapi
gen-vppbinapi: install-binapi-generator
	mkdir -p $(THIRD_PARTY); \
	$(GOBIN)/binapi-generator \
		--input=/usr/share/vpp/api/ \
		--output-dir=$(THIRD_PARTY)/vppbinapi \
		--import-prefix=github.com/hyperproj/hyperloop/third_party/vppbinapi
