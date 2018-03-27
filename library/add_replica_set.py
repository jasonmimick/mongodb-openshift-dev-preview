#!/usr/bin/python

from ansible.module_utils.basic import *

def gen_hostname(data,i):
  s = str(i)
  hostname = data['cluster_hostname'].replace(data['hostname_token'],s)
  return hostname

def get_replica_set_index(replica_set_name,auto_config):
  doesnt_exist = False
  replica_set_index=-1
  
  len_replicaSets = len(auto_config['replicaSets'])
  # There are none, so doesn't exist and will
  # be first
  if len_replicaSets==0:
    replica_set_index = 0
    doesnt_exist = True
    return replica_set_index, doesnt_exist

  # Try to find by _id == name
  for idx,replSet in auto_config['replicaSets']:
    if replSet._id == replica_set_name:
      replica_set_index = idx
  
  # If replica_set_index still -1, doesn't exist
  if replica_set_index==-1:
    replica_set_index = len_replicaSets 
    doesnt_exist = True
  return replica_set_index, doesnt_exist

def replica_set_present(data):
  
  def get_nvpair(name,default_value):
    value = data.get(name, default_value)
    if not value:
      value
    return { name : value }
  
  number_nodes = data['replica_set_nodes']
  if not isinstance(number_nodes,int):
    try:
      number_nodes = int(number_nodes)
    except Exception as e:
      print "Can't convert number_of_nodes='%s' to int" % number_of_nodes
      print "Exception was '%s'" % s
      print "Defaulting to 3 nodes"
      number_of_nodes = 3
  auto_config = data['automation_config']
  replica_set_name = data['cluster_name']
  replica_set_index, doesnt_exist = get_replica_set_index(replica_set_name,
                                            auto_config)

  # If this repl set doesn't doesn't exist,
  # then we sure don't need to add it.
  # TODO: What if the number of nodes isn't the same?
  if not doesnt_exist:
    return { "auto_config" : auto_config, 
             "meta" : "replica set %s was already there?" % replica_set_name }
    
  
  auto_config = gen_repl_set_auto_config( data, number_nodes )
 
 
  return { "auto_config" : auto_config, "meta" : "Added replica set %s" % replica_set_name }


# remove cluster_name from automationConfig
def replica_set_absent(data):
  auto_config = data['automation_config']
  replica_set_name = data['cluster_name']
  
  # i is the length of the 'replicaSets' array in the automation config
  replica_set_index, doesnt_exist = get_replica_set_index(replica_set_name,
                                            auto_config)
  
  msg = ""
  if not doesnt_exist:
    del auto_config['replicaSets'][replica_set_index]
    msg = "Relica set %s removed" % replica_set_name
  else:
    msg = "Replica set %s didn't exist" % replica_set_name
  return { "auto_config" : auto_config, "meta" : msg }


def main():

  fields = {
    "hostname_token" : { "required" : True, "type" : "str" },
    "cluster_hostname" : { "required" : True, "type" : "str" },
    "mongodb_logpath" : { "required" : True, "type" : "str" },
    "mongodb_dbpath" : { "required" : True, "type" : "str" },
    "cluster_name" : { "required" : True, "type" : "str" },
    "automation_config" : { "required" : True, "type" : "dict" },
    "mongodb_port" : { "type" : "int", "default" : 27000 },
    "replica_set_nodes" : { "type" : "int", "default" : 3 },
    "mongodb_version" : { "type" : "str", "required" : True },
    "state" : { 
      "default" : "present",
      "choices" : [ "present", "absent" ],
      "type" : "str"
    }
  }

  choice_map = { 
    "present" : replica_set_present,
    "absent"  : replica_set_absent
  }

  module = AnsibleModule(argument_spec=fields)
  response = {"hello": "world", "cluster_name" : module.params['cluster_name'] }
  response = choice_map.get(module.params['state'])(module.params)
  module.exit_json(changed=False, meta=response)

def gen_repl_set_auto_config( data, number_nodes ): 
    rs = { "options": {
        "downloadBase": "/var/lib/mongodb-mms-automation"
         },
         "mongoDbVersions": [
             {"name": data['mongodb_version']}
         ],
         "backupVersions": [],
         "monitoringVersions": [],
         "processes": [],
         "replicaSets": [
             { "_id" : data['cluster_name'],
               "members" : []
             }
          ],
          "roles": [],
          "sharding": []
    }
    
    for i in range(0,number_nodes):
        hostname = gen_hostname(data,i)
        name = "%s_%d" % ( data['cluster_name'], i)
        b = {
            "hostname": hostname,
            "logRotate": {
                "sizeThresholdMB": 1000,
                "timeThresholdHrs": 24
            }
        }
        rs['backupVersions'].append(b)
        m = {
            "hostname": hostname,
            "logRotate": {
                "sizeThresholdMB": 1000,
                "timeThresholdHrs": 24
            }
        }
        rs['monitoringVersions'].append(m)
        p = {
            "args2_6": {
                "net": {
                    "port": data['mongodb_port'],
                    "bindIp": "0.0.0.0"
                },
                "replication": {
                    "replSetName": data['cluster_name']
                },
                "storage": {
                    "dbPath": data['mongodb_dbpath'] 
                },
                "systemLog": {
                    "destination": "file",
                    "path": data['mongodb_logpath']
                }
            },
            "hostname": hostname,
            "logRotate": {
                "sizeThresholdMB": 1000,
                "timeThresholdHrs": 24
            },
            "name": name,
            "processType": "mongod",
            "version": data['mongodb_version'],
            "featureCompatibilityVersion": data['mongodb_version'][0:3],
            "authSchemaVersion": 5
        }
        rs['processes'].append(p)
        rs_member = {
            "_id": i,
            "host": name
        }
        rs['replicaSets'][0]['members'].append(rs_member)
        
    return rs

if __name__ == '__main__':  
    main()
