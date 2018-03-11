#!/usr/bin/python

from ansible.module_utils.basic import *

def gen_hostname(data,i)
  hostname = data['cluster_hostname'].replace(data['hostname_token'],i)
  return hostname
#  prefix = data['mms_cluster_hostname_prefix']
#  project = data['mms_project_name']
#  cluster = data['mms_cluster-name']
#  domain = data['openshift_domain']
#  hostname = "%s-%s-%s-%s.%s" % (prefix,project,cluster,i,domain)
#  hostname = hostname.lower()   # doesn't like caps
#  print "gen_hostname => %s" % hostname
#  return hostname

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
    
  
  # TODO: Move these default values into playbook params
  rs = { "_id" : replica_set_name, "members" : [ ] }
  auto_config['replicaSets'].append(rs)
  processes = []
  backupVersions = []
  monitoringVersions = []
  for i in range(0,number_nodes):
    hostname = gen_hostname(data,i)
    rs_member = {}
    rs_member.update( {'_id' : i} )
    rs_member.update( get_nvpair('arbiterOnly',False) )
    rs_member.update( get_nvpair('hidden',False) )
    rs_member.update({'host' : hostname})
    rs_member.update( get_nvpair('priority',1.0) )
    rs_member.update( get_nvpair('slaveDelay',0) )
    rs_member.update( get_nvpair('votes',1) )
    auto_config['replicaSets'][replica_set_index]['members'].append(rs_member)
    process = {}
    process['args2_6']= {
        'net' : { 'port' : 27000 },
        'replication' : { 'replSetName' : replica_set_name },
        'storage' : { 'dbPath' : '/data' },
        'systemLog' : { 'destination' : 'file',
                        'path' : '/data/mongodb.log' },
    }
    process['logRotate'] = { 'sizeThresholdMB': 1000,
                             'timeThresholdHrs': 24
    }
    process['hostname'] = hostname
    #process['name'] = 'mongodb-server-%s-%s' % (replica_set_name,i)
    process['name'] = hostname
    process['processType'] = 'mongod'
    process['version'] = data['mongodb_version']
    process['authSchemaVersion'] = 5
    process['featureCompatibilityVersion'] = data['mongodb_version'][0:3]
    processes.append( process )
    backupVersion = { "hostname": hostname }

    #     "logPath": "/var/vcap/sys/log/mongod_node/backup-agent.log",$
    #     "logRotate": {$
    #         "sizeThresholdMB": 1000,$
    #         "timeThresholdHrs": 24$
    monitoringVersion = { "hostname": hostname }
    backupVersions.append( backupVersion )
    monitoringVersions.append( monitoringVersion )
  auto_config['processes']=processes
  # add agents
  auto_config['backupVersions']=backupVersions
  auto_config['monitoringVersions']=monitoringVersions
 
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


if __name__ == '__main__':  
    main()
