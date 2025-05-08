module github.com/hyperproj/hyperloop

go 1.24.2

require (
	github.com/avast/retry-go/v4 v4.6.1
	github.com/blang/semver v3.5.1+incompatible
	github.com/containernetworking/cni v1.3.0
	go.fd.io/govpp v0.11.0
	google.golang.org/grpc v1.67.3
	google.golang.org/protobuf v1.36.6
	k8s.io/apimachinery v0.33.0-beta.0
	k8s.io/klog/v2 v2.130.1
)

require (
	github.com/inconshreveable/mousetrap v1.1.0 // indirect
	github.com/vishvananda/netns v0.0.4 // indirect
	k8s.io/utils v0.0.0-20241104100929-3ea5e8cea738 // indirect
)

require (
	github.com/bmatcuk/doublestar/v4 v4.0.2 // indirect
	github.com/client9/misspell v0.3.4 // indirect
	github.com/go-logr/logr v1.4.2 // indirect
	github.com/go-logr/zapr v1.3.0 // indirect
	github.com/google/addlicense v1.1.1 // indirect
	github.com/lunixbochs/struc v0.0.0-20200521075829-a4cb8d33dbbe // indirect
	github.com/spf13/afero v1.12.0 // indirect
	github.com/spf13/cobra v1.9.1
	github.com/spf13/pflag v1.0.6
	go.uber.org/multierr v1.10.0 // indirect
	go.uber.org/zap v1.27.0 // indirect
	golang.org/x/net v0.33.0 // indirect
	golang.org/x/sync v0.11.0 // indirect
	golang.org/x/sys v0.30.0 // indirect
	golang.org/x/text v0.22.0 // indirect
	google.golang.org/genproto/googleapis/rpc v0.0.0-20241223144023-3abc09e42ca8 // indirect
	sigs.k8s.io/controller-runtime/tools/setup-envtest v0.0.0-20250505003155-b6c5897febe5 // indirect
	sigs.k8s.io/yaml v1.4.0 // indirect
)

tool (
	github.com/client9/misspell/cmd/misspell
	github.com/google/addlicense
	sigs.k8s.io/controller-runtime/tools/setup-envtest
)
