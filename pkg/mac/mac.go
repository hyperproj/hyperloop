/*
Copyright © 2023 The Hyperloop Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
package mac

import (
	"crypto/rand"
	"fmt"
	"net"
)

func NewRandHWAddr() (net.HardwareAddr, error) {
	buf := make([]byte, 6)
	if _, err := rand.Read(buf); err != nil {
		return nil, fmt.Errorf("failed to retrieve 6 rand bytes: %v", err)
	}

	// Set locally administered addresses bit and reset multicast bit
	buf[0] = (buf[0] & 0xfe) | 0x02
	return buf, nil
}
