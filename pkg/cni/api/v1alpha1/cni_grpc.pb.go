// Copyright The Hyperloop Authors
// SPDX-License-Identifier: Apache-2.0

// Code generated by protoc-gen-go-grpc. DO NOT EDIT.
// versions:
// - protoc-gen-go-grpc v1.5.1
// - protoc             v6.30.2
// source: pkg/cni/api/v1alpha1/cni.proto

package v1alpha1

import (
	context "context"
	grpc "google.golang.org/grpc"
	codes "google.golang.org/grpc/codes"
	status "google.golang.org/grpc/status"
)

// This is a compile-time assertion to ensure that this generated file
// is compatible with the grpc package it is being compiled against.
// Requires gRPC-Go v1.64.0 or later.
const _ = grpc.SupportPackageIsVersion9

const (
	Cni_Add_FullMethodName   = "/h.hl.pkg.cni.api.v1alpha1.Cni/Add"
	Cni_Check_FullMethodName = "/h.hl.pkg.cni.api.v1alpha1.Cni/Check"
	Cni_Del_FullMethodName   = "/h.hl.pkg.cni.api.v1alpha1.Cni/Del"
)

// CniClient is the client API for Cni service.
//
// For semantics around ctx use and closing/ending streaming RPCs, please refer to https://pkg.go.dev/google.golang.org/grpc/?tab=doc#ClientConn.NewStream.
type CniClient interface {
	Add(ctx context.Context, in *CniRequest, opts ...grpc.CallOption) (*CniResponse, error)
	Check(ctx context.Context, in *CniRequest, opts ...grpc.CallOption) (*CniResponse, error)
	Del(ctx context.Context, in *CniRequest, opts ...grpc.CallOption) (*CniResponse, error)
}

type cniClient struct {
	cc grpc.ClientConnInterface
}

func NewCniClient(cc grpc.ClientConnInterface) CniClient {
	return &cniClient{cc}
}

func (c *cniClient) Add(ctx context.Context, in *CniRequest, opts ...grpc.CallOption) (*CniResponse, error) {
	cOpts := append([]grpc.CallOption{grpc.StaticMethod()}, opts...)
	out := new(CniResponse)
	err := c.cc.Invoke(ctx, Cni_Add_FullMethodName, in, out, cOpts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *cniClient) Check(ctx context.Context, in *CniRequest, opts ...grpc.CallOption) (*CniResponse, error) {
	cOpts := append([]grpc.CallOption{grpc.StaticMethod()}, opts...)
	out := new(CniResponse)
	err := c.cc.Invoke(ctx, Cni_Check_FullMethodName, in, out, cOpts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *cniClient) Del(ctx context.Context, in *CniRequest, opts ...grpc.CallOption) (*CniResponse, error) {
	cOpts := append([]grpc.CallOption{grpc.StaticMethod()}, opts...)
	out := new(CniResponse)
	err := c.cc.Invoke(ctx, Cni_Del_FullMethodName, in, out, cOpts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

// CniServer is the server API for Cni service.
// All implementations must embed UnimplementedCniServer
// for forward compatibility.
type CniServer interface {
	Add(context.Context, *CniRequest) (*CniResponse, error)
	Check(context.Context, *CniRequest) (*CniResponse, error)
	Del(context.Context, *CniRequest) (*CniResponse, error)
	mustEmbedUnimplementedCniServer()
}

// UnimplementedCniServer must be embedded to have
// forward compatible implementations.
//
// NOTE: this should be embedded by value instead of pointer to avoid a nil
// pointer dereference when methods are called.
type UnimplementedCniServer struct{}

func (UnimplementedCniServer) Add(context.Context, *CniRequest) (*CniResponse, error) {
	return nil, status.Errorf(codes.Unimplemented, "method Add not implemented")
}
func (UnimplementedCniServer) Check(context.Context, *CniRequest) (*CniResponse, error) {
	return nil, status.Errorf(codes.Unimplemented, "method Check not implemented")
}
func (UnimplementedCniServer) Del(context.Context, *CniRequest) (*CniResponse, error) {
	return nil, status.Errorf(codes.Unimplemented, "method Del not implemented")
}
func (UnimplementedCniServer) mustEmbedUnimplementedCniServer() {}
func (UnimplementedCniServer) testEmbeddedByValue()             {}

// UnsafeCniServer may be embedded to opt out of forward compatibility for this service.
// Use of this interface is not recommended, as added methods to CniServer will
// result in compilation errors.
type UnsafeCniServer interface {
	mustEmbedUnimplementedCniServer()
}

func RegisterCniServer(s grpc.ServiceRegistrar, srv CniServer) {
	// If the following call pancis, it indicates UnimplementedCniServer was
	// embedded by pointer and is nil.  This will cause panics if an
	// unimplemented method is ever invoked, so we test this at initialization
	// time to prevent it from happening at runtime later due to I/O.
	if t, ok := srv.(interface{ testEmbeddedByValue() }); ok {
		t.testEmbeddedByValue()
	}
	s.RegisterService(&Cni_ServiceDesc, srv)
}

func _Cni_Add_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(CniRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(CniServer).Add(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: Cni_Add_FullMethodName,
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(CniServer).Add(ctx, req.(*CniRequest))
	}
	return interceptor(ctx, in, info, handler)
}

func _Cni_Check_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(CniRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(CniServer).Check(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: Cni_Check_FullMethodName,
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(CniServer).Check(ctx, req.(*CniRequest))
	}
	return interceptor(ctx, in, info, handler)
}

func _Cni_Del_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(CniRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(CniServer).Del(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: Cni_Del_FullMethodName,
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(CniServer).Del(ctx, req.(*CniRequest))
	}
	return interceptor(ctx, in, info, handler)
}

// Cni_ServiceDesc is the grpc.ServiceDesc for Cni service.
// It's only intended for direct use with grpc.RegisterService,
// and not to be introspected or modified (even as a copy)
var Cni_ServiceDesc = grpc.ServiceDesc{
	ServiceName: "h.hl.pkg.cni.api.v1alpha1.Cni",
	HandlerType: (*CniServer)(nil),
	Methods: []grpc.MethodDesc{
		{
			MethodName: "Add",
			Handler:    _Cni_Add_Handler,
		},
		{
			MethodName: "Check",
			Handler:    _Cni_Check_Handler,
		},
		{
			MethodName: "Del",
			Handler:    _Cni_Del_Handler,
		},
	},
	Streams:  []grpc.StreamDesc{},
	Metadata: "pkg/cni/api/v1alpha1/cni.proto",
}
