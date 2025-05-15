// Copyright The Hyperloop Authors
// SPDX-License-Identifier: Apache-2.0

package version

import (
	"encoding/json"
	"fmt"
	"runtime"
)

// These variables typically come from -ldflags settings
var (
	gitVersion   = "unknown"
	gitSHA       = "unknown"
	gitTreeState = "unknown"
	buildDate    = "unknown"
)

type Info struct {
	GitVersion   string `json:"gitVersion"`
	GitSHA       string `json:"gitSHA"`
	GitTreeState string `json:"gitTreeState"`
	BuildDate    string `json:"buildDate"`
	GoVersion    string `json:"goVersion"`
	GoCompiler   string `json:"goCompiler"`
	Platform     string `json:"platform"`
}

func (i Info) String() string {
	jsonBytes, _ := json.Marshal(i)
	return string(jsonBytes)
}

func GetInfo() Info {
	return Info{
		GitVersion:   gitVersion,
		GitSHA:       gitSHA,
		GitTreeState: gitTreeState,
		BuildDate:    buildDate,
		GoVersion:    runtime.Version(),
		GoCompiler:   runtime.Compiler,
		Platform:     fmt.Sprintf("%s/%s", runtime.GOOS, runtime.GOARCH),
	}
}
