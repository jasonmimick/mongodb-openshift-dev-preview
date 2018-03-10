FROM ansibleplaybookbundle/apb-base

LABEL "com.redhat.apb.spec"=\
"YWdlbnRzb25seTogJmFnZW50c29ubHkKICAtIG5hbWU6IG1tc19iYXNlX3VybAogICAgdGl0bGU6\
IE9wcyBNYW5hZ2VyIFVSTAogICAgdHlwZTogc3RyaW5nCiAgICByZXF1aXJlZDogVHJ1ZQogICAg\
ZGVmYXVsdDogJ2h0dHA6Ly9sb2NhbGhvc3Q6ODA4MCcKICAgIGRpc3BsYXlfZ3JvdXA6IE1vbmdv\
REIgT3BzIE1hbmFnZXIgQ29uZmlndXJhdGlvbgogIC0gbmFtZTogbW1zX3VzZXIKICAgIHRpdGxl\
OiBPcHMgTWFuYWdlciB1c2VyCiAgICB0eXBlOiBzdHJpbmcKICAgIHJlcXVpcmVkOiBUcnVlCiAg\
ICBkZWZhdWx0OiBqYXNvbi5taW1pY2tAbW9uZ29kYi5jb20KICAgIGRpc3BsYXlfZ3JvdXA6IE1v\
bmdvREIgT3BzIE1hbmFnZXIgQ29uZmlndXJhdGlvbgogIC0gbmFtZTogbW1zX3VzZXJfYXBpa2V5\
CiAgICB0aXRsZTogVXNlcidzIE9wcyBNYW5hZ2VyIEFQSSBrZXkKICAgIHR5cGU6IHN0cmluZwog\
ICAgcmVxdWlyZWQ6IFRydWUKICAgIGRlZmF1bHQ6IDBmNGE3MmVlLWQ1YzYtNDcyOS1hZmYwLTgx\
ZmJjYjkzMWY3NQogICAgZGlzcGxheV90eXBlOiBzdHJpbmcKICAgIGRpc3BsYXlfZ3JvdXA6IE1v\
bmdvREIgT3BzIE1hbmFnZXIgQ29uZmlndXJhdGlvbgogIC0gbmFtZTogbW1zX2FwaV91cmkKICAg\
IHRpdGxlOiBNb25nb0RCIE9wcyBNYW5hZ2VyIEFQSSBVUkkKICAgIGRlZmF1bHQ6ICdodHRwOi8v\
bG9jYWxob3N0OjgwODAvYXBpL3B1YmxpYy92MS4wJwogICAgdHlwZTogc3RyaW5nCiAgLSBuYW1l\
OiBtbXNfcHJvamVjdF9uYW1lCiAgICB0aXRsZTogUHJvamVjdCB0byBjcmVhdGUgcmVwbGljYSBz\
ZXQgaW4KICAgIGRlZmF1bHQ6ICIiCiAgICB0eXBlOiBzdHJpbmcKICAtIG5hbWU6IG1tc19kZWZh\
dWx0X29yZ0lkCiAgICB0aXRsZTogT3JnYW5pemF0aW9uIGZvciBuZXcgcHJvamVjdAogICAgZGVm\
YXVsdDogIjVhOTM2MmQ2NmNlZjQ3MGMzNzVhOTg1NSIKICAgIHR5cGU6IHN0cmluZwogIC0gbmFt\
ZTogbW1zX2FwaV90aW1lb3V0CiAgICB0aXRsZTogTW9uZ29EQiBPcHMgTWFuYWdlciBBUEkgVGlt\
ZW91dCBpbiBzZWNvbmRzCiAgICBkZWZhdWx0OiAiMzAiCiAgICB0eXBlOiBzdHJpbmcKICAtIG5h\
bWU6IGNsdXN0ZXJfbmFtZQogICAgdGl0bGU6IE1vbmdvREIgQ2x1c3RlciBOYW1lCiAgICB0eXBl\
OiBzdHJpbmcKICAgIGRlZmF1bHQ6IAogICAgcmVxdWlyZWQ6IFRydWUKICAgIGRpc3BsYXlfZ3Jv\
dXA6IE1vbmdvREIgQ2x1c3RlciBDb25maWd1cmF0aW9uCiAgLSBuYW1lOiBtb25nb2RiX3ZlcnNp\
b24KICAgIHRpdGxlOiBNb25nb0RCIFZlcnNpb24KICAgIHR5cGU6IGVudW0KICAgIGRlZmF1bHQ6\
ICczLjQuMTMnCiAgICBlbnVtOiBbICczLjQuMTMnLCAnMy42LjMnIF0KICAgIHJlcXVpcmVkOiBU\
cnVlCiAgICBkaXNwbGF5X2dyb3VwOiBNb25nb0RCIENsdXN0ZXIgQ29uZmlndXJhdGlvbgogIC0g\
bmFtZTogbW9uZ29kYl9wb3J0IAogICAgdGl0bGU6IFBvcnQgZm9yIE1vbmdvREIgdG8gbGlzdGVu\
IG9uCiAgICB0eXBlOiBzdHJpbmcKICAgIGRlZmF1bHQ6ICIyNzAwMCIKICAgIHJlcXVpcmVkOiBU\
cnVlCiAgICBkaXNwbGF5X2dyb3VwOiBNb25nb0RCIENsdXN0ZXIgQ29uZmlndXJhdGlvbgogIC0g\
bmFtZTogZGlza19zaXplX2diCiAgICB0aXRsZTogU2l6ZSBpbiBHYiBmb3IgcGVyc2lzdGVudCBz\
dG9yYWdlIGNsYWltIG9uIGRhdGEgbm9kZQogICAgZGVmYXVsdDogIjUiCiAgICB0eXBlOiBzdHJp\
bmcKICAgIGRpc3BsYXlfZ3JvdXA6IE1vbmdvREIgQ2x1c3RlciBDb25maWd1cmF0aW9uCiAgLSBu\
YW1lOiBudW1iZXJfb2ZfYWdlbnRzX29ubHlfcG9kcwogICAgdGl0bGU6IE51bWJlciBvZiBhZ2Vu\
dHMtb25seSBwb2RzCiAgICB0eXBlOiBzdHJpbmcKICAgIGRlZmF1bHQ6ICIxMyIKICAgIHJlcXVp\
cmVkOiBUcnVlCiAgICBkaXNwbGF5X2dyb3VwOiBNb25nb0RCIEFnZW50cyBPbmx5IFBvZHMgQ29u\
ZmlndXJhdGlvbgoKcmVwbGljYXNldDogJnJlcGxpY2FzZXQKICAtIG5hbWU6IG1tc19iYXNlX3Vy\
bAogICAgdGl0bGU6IE9wcyBNYW5hZ2VyIFVSTAogICAgdHlwZTogc3RyaW5nCiAgICByZXF1aXJl\
ZDogVHJ1ZQogICAgZGVmYXVsdDogJ2h0dHA6Ly9sb2NhbGhvc3Q6ODA4MCcKICAgIGRpc3BsYXlf\
Z3JvdXA6IE1vbmdvREIgT3BzIE1hbmFnZXIgQ29uZmlndXJhdGlvbgogIC0gbmFtZTogbW1zX3Vz\
ZXIKICAgIHRpdGxlOiBPcHMgTWFuYWdlciB1c2VyCiAgICB0eXBlOiBzdHJpbmcKICAgIHJlcXVp\
cmVkOiBUcnVlCiAgICBkZWZhdWx0OiBqYXNvbi5taW1pY2tAbW9uZ29kYi5jb20KICAgIGRpc3Bs\
YXlfZ3JvdXA6IE1vbmdvREIgT3BzIE1hbmFnZXIgQ29uZmlndXJhdGlvbgogIC0gbmFtZTogbW1z\
X3VzZXJfYXBpa2V5CiAgICB0aXRsZTogVXNlcidzIE9wcyBNYW5hZ2VyIEFQSSBrZXkKICAgIHR5\
cGU6IHN0cmluZwogICAgcmVxdWlyZWQ6IFRydWUKICAgIGRlZmF1bHQ6IDBmNGE3MmVlLWQ1YzYt\
NDcyOS1hZmYwLTgxZmJjYjkzMWY3NQogICAgZGlzcGxheV90eXBlOiBzdHJpbmcKICAgIGRpc3Bs\
YXlfZ3JvdXA6IE1vbmdvREIgT3BzIE1hbmFnZXIgQ29uZmlndXJhdGlvbgogIC0gbmFtZTogbW1z\
X2FwaV91cmkKICAgIHRpdGxlOiBNb25nb0RCIE9wcyBNYW5hZ2VyIEFQSSBVUkkKICAgIGRlZmF1\
bHQ6ICdodHRwOi8vbG9jYWxob3N0OjgwODAvYXBpL3B1YmxpYy92MS4wJwogICAgdHlwZTogc3Ry\
aW5nCiAgLSBuYW1lOiBtbXNfcHJvamVjdF9uYW1lCiAgICB0aXRsZTogUHJvamVjdCB0byBjcmVh\
dGUgcmVwbGljYSBzZXQgaW4KICAgIGRlZmF1bHQ6ICIiCiAgICB0eXBlOiBzdHJpbmcKICAtIG5h\
bWU6IG1tc19kZWZhdWx0X29yZ0lkCiAgICB0aXRsZTogT3JnYW5pemF0aW9uIGZvciBuZXcgcHJv\
amVjdAogICAgZGVmYXVsdDogIjVhOTM2MmQ2NmNlZjQ3MGMzNzVhOTg1NSIKICAgIHR5cGU6IHN0\
cmluZwogIC0gbmFtZTogbW1zX2FwaV90aW1lb3V0CiAgICB0aXRsZTogTW9uZ29EQiBPcHMgTWFu\
YWdlciBBUEkgVGltZW91dCBpbiBzZWNvbmRzCiAgICBkZWZhdWx0OiAiMzAiCiAgICB0eXBlOiBz\
dHJpbmcKICAtIG5hbWU6IGNsdXN0ZXJfbmFtZQogICAgdGl0bGU6IE1vbmdvREIgQ2x1c3RlciBO\
YW1lCiAgICB0eXBlOiBzdHJpbmcKICAgIGRlZmF1bHQ6IAogICAgcmVxdWlyZWQ6IFRydWUKICAg\
IGRpc3BsYXlfZ3JvdXA6IE1vbmdvREIgQ2x1c3RlciBDb25maWd1cmF0aW9uCiAgLSBuYW1lOiBt\
b25nb2RiX3ZlcnNpb24KICAgIHRpdGxlOiBNb25nb0RCIFZlcnNpb24KICAgIHR5cGU6IGVudW0K\
ICAgIGRlZmF1bHQ6ICczLjQuMTMnCiAgICBlbnVtOiBbICczLjQuMTMnLCAnMy42LjMnIF0KICAg\
IHJlcXVpcmVkOiBUcnVlCiAgICBkaXNwbGF5X2dyb3VwOiBNb25nb0RCIENsdXN0ZXIgQ29uZmln\
dXJhdGlvbgogIC0gbmFtZTogbW9uZ29kYl9wb3J0IAogICAgdGl0bGU6IFBvcnQgZm9yIE1vbmdv\
REIgdG8gbGlzdGVuIG9uCiAgICB0eXBlOiBzdHJpbmcKICAgIGRlZmF1bHQ6ICIyNzAwMCIKICAg\
IHJlcXVpcmVkOiBUcnVlCiAgICBkaXNwbGF5X2dyb3VwOiBNb25nb0RCIENsdXN0ZXIgQ29uZmln\
dXJhdGlvbgogIC0gbmFtZTogZGlza19zaXplX2diCiAgICB0aXRsZTogU2l6ZSBpbiBHYiBmb3Ig\
cGVyc2lzdGVudCBzdG9yYWdlIGNsYWltIG9uIGRhdGEgbm9kZQogICAgZGVmYXVsdDogIjUiCiAg\
ICB0eXBlOiBzdHJpbmcKICAgIGRpc3BsYXlfZ3JvdXA6IE1vbmdvREIgQ2x1c3RlciBDb25maWd1\
cmF0aW9uCiAgLSBuYW1lOiBub2Rlc19wZXJfcmVwbGljYXNldAogICAgdGl0bGU6IE51bWJlciBv\
ZiBub2RlcyBpbiBSZXBsaWNhIFNldAogICAgdHlwZTogc3RyaW5nIAogICAgZGVmYXVsdDogIjMi\
CiAgICByZXF1aXJlZDogVHJ1ZQogICAgZGlzcGxheV9ncm91cDogTW9uZ29EQiBSZXBsaWNhIFNl\
dCBDb25maWd1cmF0aW9uCgoKCnZlcnNpb246IDAuMQpuYW1lOiBtb25nb2RiLWVudGVycHJpc2UK\
ZGVzY3JpcHRpb246IERlcGxveSBNb25nb0RCIGludG8gT3BlbnNoaWZ0IHRocm91Z2ggT3BzIE1h\
bmFnZXIKYmluZGFibGU6IFRydWUKYXN5bmM6IG9wdGlvbmFsCm1ldGFkYXRhOgogIGRpc3BsYXlO\
YW1lOiBNb25nb0RCIEVudGVycHJpc2UKICBkZXBlbmRlbmNpZXM6IFsgJ2NlbnRvcycgXQogIGlt\
YWdlVXJsOiBodHRwczovL3d3dy5tb25nb2RiLmNvbS9hc3NldHMvaW1hZ2VzL2Nsb3VkL2F0bGFz\
L2lsbHVzdHJhdGlvbnMvbGl2ZS1pbXBvcnQucG5nCiAgZG9jdW1lbnRhdGlvblVybDogaHR0cHM6\
Ly9naXRodWIuY29tL2phc29ubWltaWNrL21vbmdvZGItb3BlbnNoaWZ0LWRldi1wcmV2aWV3CnBs\
YW5zOgogIC0gbmFtZTogcmVwbGljYXNldAogICAgZGVzY3JpcHRpb246IFRoaXMgcGxhbiBkZXBs\
b3lzIGEgTW9uZ29EQiByZXBsaWNhIHNldAogICAgZnJlZTogVHJ1ZQogICAgbWV0YWRhdGE6IAog\
ICAgIGRpc3BsYXlOYW1lOiBNb25nb0RCIFJlcGxpY2EgU2V0CiAgICAgbG9uZ0Rlc2NyaXB0aW9u\
OiBUaGlzIHBsYW4gZGVwbG95cyBhIE1vbmdvREIgcmVwbGljYQogICAgIGNvc3Q6ICQwLjAwCiAg\
ICBwYXJhbWV0ZXJzOiAqcmVwbGljYXNldAogIC0gbmFtZTogYWdlbnQtb25seQogICAgZGVzY3Jp\
cHRpb246IERlcGxveXMgbi1wb2RzIHdpdGggb25seSB0aGUgYWdlbnRzCiAgICBmcmVlOiBUcnVl\
CiAgICBtZXRhZGF0YToKICAgICAgZGVzY3JpcHRpb246IE1vbmdvREIgQWdlbnRzLU9ubHkKICAg\
ICAgbG9uZ0Rlc2NyaXB0aW9uOiBUaGlzIHBsYW4gZGVwbG95cyBzb21lIG51bWJlciBvZiBwb2Rz\
IGVhY2ggd2l0aCBvbmx5IDEgb2YgZWFjaCB0eXBlIG9mIE1vbmdvREIgT3BzIE1hbmFnZXIgYWdl\
bnQuIE5vIGFjdHVhbCBNb25nb0RCIGluc3RhbmNlcyBhcmUgcHJvdmlzaW9uZWQuIEVhY2ggYWdl\
bnQgaXMgYXNzb2NpYXRlZCB3aXRoIHRoZSBkZXNpcmVkIHByb2plY3QuIFRoaXMgYmFzZSBwb3Mg\
YWxsb3dzIHVzZXJzIHRvIGNvbmZpZ3VyZSBtb3JlIGFkdmFuY2VkIGNsdXN0ZXJzIGRpcmVjdGx5\
IHRocm91Z2ggTW9uZ29EQiBPcHMgTWFuYWdlci4KICAgICAgY29zdDogJDEsMDAwLDAwMFVTCiAg\
ICBwYXJhbWV0ZXJzOiAqYWdlbnRzb25seQoK"






























COPY playbooks /opt/apb/actions
COPY roles /opt/ansible/roles
COPY library /opt/ansible/library
RUN chmod -R g=u /opt/{ansible,apb}
ENV ANSIBLE_LIBRARY /opt/ansible/library
ENV ANSIBLE_ROLES_PATH /opt/ansible/roles:/etc/ansible/roles
USER apb
