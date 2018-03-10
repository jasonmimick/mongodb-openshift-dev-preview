#!/usr/bin/python

from ansible.module_utils.basic import *

def get_replica_set_index(replica_set_name,auto_config):

  doesnt_exist = False
  replica_set_index=-1
  
  if len(auto_config['replicaSets'])==0:
    replica_set_index = 0

  for idx,replSet in auto_config['replicaSets']:
    if replSet._id == replica_set_name:
      replica_set_index = idx
  
  len_replicaSets = len(auto_config['replicaSets'])
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
  auto_config = data['automation_config']
  replica_set_name = data['cluster_name']
  replica_set_index, doesnt_exist = get_replica_set_index(replica_set_name,
                                            auto_config)

  # If this repl set doesn't doesn't exist,
  # then we sure don't need to add it.
  # TODO: What if the number of nodes isn't the same?
  if not doesnt_exist:
    return { "auto_config" : auto_config, 
             "meta" : "Added replica set %s" % replica_set_name }
    
  
  # TODO: Move these default values into playbook params
  rs = { "_id" : replica_set_name, "members" : [ ] }
  auto_config['replicaSets'].append(rs)
  for i in range(0,number_nodes):
    rs_member = {}
    rs_member.update( {'_id' : i} )
    rs_member.update( get_nvpair('arbiterOnly',False) )
    rs_member.update( get_nvpair('hidden',False) )
    rs_member.update( get_nvpair('host%s'%i,'server.com') )
    rs_member.update( get_nvpair('priority',1.0) )
    rs_member.update( get_nvpair('slaveDelay',0) )
    rs_member.update( get_nvpair('votes',1) )
    auto_config['replicaSets'][replica_set_index]['members'].append(rs_member)
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
    "cluster_name" : { "required" : True, "type" : "str" },
    "automation_config" : { "required" : True, "type" : "dict" },
    "replica_set_nodes" : { "type" : "int" },
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


if __name__ == '__main__':  
    main()
