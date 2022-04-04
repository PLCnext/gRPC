# protoc can be downloaded from https://github.com/protocolbuffers/protobuf/releases/
set PROTOC=protoc.exe
# the plugin can be build from source https://github.com/grpc/grpc/tree/master/src/cpp
set PLUGIN=grpc_cpp_plugin.exe
# The base proto files from google can be downloaded from https://github.com/protocolbuffers/protobuf/releases/
# Choose your programming language, the SDKPATH hast to point to the src folder in the downloaded archive.
REM set SDKPATH=.\python
# For C++ the files are also included in the PLCnext controller SDK.
set SDKPATH=C:\SDKs\AXCF2152\2022.0\sysroots\cortexa9t2hf-neon-pxc-linux-gnueabi\usr\include

set output=.\ServiceStubs\
set protopath=\protobuf
if not exist %output% mkdir %output%

set servicepath[0]=
set servicepath[1]=\Device\Interface
set servicepath[2]=\Io\Axioline
set servicepath[3]=\Plc
set servicepath[4]=\Plc\Gds
set servicepath[5]=\Services\DataLogger
set servicepath[6]=\Services\NotificationLogger
set servicepath[7]=\System\Commons\Io
set servicepath[8]=\System\Lm
set servicepath[9]=\System\Nm
set servicepath[10]=\System\Security
set servicepath[11]=\System\Um

for /L %%n in (0,1,11) do (
    Call %PROTOC% --proto_path=%SDKPATH% --proto_path=.%protopath% --grpc_out=%output% --plugin=protoc-gen-grpc=%PLUGIN% .%protopath%%%servicepath[%%n]%%\*.proto
    Call %PROTOC% --proto_path=%SDKPATH% --proto_path=.%protopath% --cpp_out=%output% .%protopath%%%servicepath[%%n]%%\*.proto
)
pause