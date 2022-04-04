# gRPC in PLCnext Technology

1. Introduction to gRPC
2. gRPC in PLCnext Technology
3. How to use gRPC
4. Quick start
5. PLCnext RSC API adaptation

## 1. Introduction to gRPC

gRPC is a modern open source high performance RPC framework. Initially is was developed at Google and now lead by the Cloud Native Computing Foundation. It is very flexible and user-friendly, it can easily put different services in communication, independently from the programming language used. For more information visit [grpc.io](https://grpc.io).

gRPC uses HTTP2 as a comunication layer while it uses [protocol buffers](https://developers.google.com/protocol-buffers/) as a serialization/deserialization and interface definition language.

A client can initiate a read request and a write request. Also a subscription to server push on variable change is available. The read/write request and response are defined in .proto files. The .proto files are used to automatically generate the code that is needed for the communication in almost any programming language.

## 2. gRPC in PLCnext Technology

In PLCnext Technology we already have some interfaces to communicate, control and exchange data with the PLCnext Runtime System.

But some of them are proprietary, others are limited in functionality, and some are limited to a single programming language.  With gRPC we add another interface used for IPC (inter process communication) and in future for RPC (remote procedural call) without all those limitations.

Using a full-featured RPC framework brings a small latency overhead for local IPC, but the overhead is outweighed by the benefits of using only a single library for IPC and RPC (RPC being an upcoming feature), and having well-defined, strongly-typed interfaces that are checked for consistency at compile time. And on top of that, it can also be used to communicate with your containerized application. gRPC in PLCnext Technology extends the C++ RSC service interface by an open-source and programming-language-independent protocol. This implements the widest range of functionalities in PLCnext Technology, and will get further enhancements in future.

## 3. How to use gRPC

First of all you will need to generate the code stub for the programming language your client will be programmed in. For this you have to use the Protobuf files located in the [protobuf](/protobuf) folder of this repository. There are also needed some base libraries from the official protobuf project. Some IDE addins do already include these, but if they are missing, you can find them for the offically supported languages on [github.com/protocolbuffers/protobuf/releases/](https://github.com/protocolbuffers/protobuf/releases/) in the release assets. In PLCnext FW 2022.0 the protobuf version 3.14 and gRPC version 1.36.4 are used. Copy the ``src/google`` folder from the archive to the folder ``python``.

Further more you will need the Protobuf compiler (protoc) and the language dependent protoc plugin. They are depending on the programming languange your client should be build in and your build system architecture. Follow the Quick Start guides on the official [grpc-website](https://grpc.io/docs/languages/) to get these.

We attached an example batch files for C++ to this repository. After the correct preparation of the folder, following the previous steps and adapting the pathes, this builds the C++ service stub for all PLCnext RSC services at once.

In the PLCnext Runtime System, by default a locally accessible server is running. Clients can connect via UNIX domain socket file path to it. In the following codeblocks, find some examples on how to establish a communication channel in the most common programming languages.

More information for all supported languages can be found on [grpc.io/docs/languages](https://grpc.io/docs/languages/).

```python
# Python example
domain_socket="unix:/var/run/plcnext/grpc.sock"
channel=grpc.insecure_channel(domain_socket)
```

```csharp
// C# example
var udsEndPoint = new UnixDomainSocketEndPoint("/run/plcnext/grpc.sock");
var connectionFactory = new UnixDomainSocketConnectionFactory(udsEndPoint);
var socketsHttpHandler = new SocketsHttpHandler
{
   ConnectCallback = connectionFactory.ConnectAsync
};
using var channel = GrpcChannel.ForAddress("http://localhost", newGrpcChannelOptions
{
   HttpHandler = socketsHttpHandler
});
```

```java
// Java example
ManagedChannel channel = NettyChannelBuilder.forAddress(new DomainSocketAddress("run/plcnext/grpc.sock"))
    .eventLoopGroup(new EpollEventLoopGroup())
    .channelType(EpollDomainSocketChannel.class)
    .usePlaintext(true)
    .build();
GrpcServicesGrpc.GrpcServicesBlockingStub client = GrpcServicesGrpc.newBlockingStub(channel);

```

For the communication between host and a client inside a container (e.g. Docker), the socket file just needs to be volume-mounted and then used accordingly from the client inside the container.

## 4. Quick start

Quick start guides for all supported languages are provided on the official [gRPC website](https://grpc.io/docs/languages/).

A first PLCnext Technology related example can be found in the PLCnext Community's Makers' Blog [How to create a client for the PLCnext Control gRPC server in C#](https://www.plcnext-community.net/makersblog/how-to-create-a-client-for-the-plcnext-control-grpc-server-in-c/).

## 5. PLCnext C++ RSC API adaptation

You can find all the protobuf interface description files on our [gRPC GitHub repository](TBD).

The interface is similar to the C++ RSC interface and does accept the same parameters. You can find the information in the dedicated chapters about the service components in the [PLCnext Info Center](https://www.plcnext.help/te/Service_Components/Service_Components.htm) or in the [API documentation](https://www.plcnext.help/te/Programming/Cpp/PLCnext_API_documentation.htm).
