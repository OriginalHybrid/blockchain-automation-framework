---
Capabilities:
{% if '2.' in network.version %}
  Channel: &ChannelCapabilities
    V2_0: true
  Orderer: &OrdererCapabilities
    V2_0: true
  Application: &ApplicationCapabilities
    V2_0: true
{% endif %}
{% if '1.4' in network.version %}
{% if consensus.name == 'kafka' %}
  Global: &ChannelCapabilities
    V1_1: true
  Orderer: &OrdererCapabilities
    V1_1: true
  Application: &ApplicationCapabilities
    V1_1: true
{% endif %}
{% if consensus.name == 'raft' %}
  Global: &ChannelCapabilities
    V1_4_3: true
  Orderer: &OrdererCapabilities
    V1_4_2: true
  Application: &ApplicationCapabilities
    V1_4_2: true
{% endif %}
{% endif %}

Application: &ApplicationDefaults
{% if '2.' in network.version %}
  ACLs: &ACLsDefault
      #---New Lifecycle System Chaincode (_lifecycle) function to policy mapping for access control--#

      # ACL policy for _lifecycle's "CheckCommitReadiness" function
      _lifecycle/CheckCommitReadiness: /Channel/Application/Writers

      # ACL policy for _lifecycle's "CommitChaincodeDefinition" function
      _lifecycle/CommitChaincodeDefinition: /Channel/Application/Writers

      # ACL policy for _lifecycle's "QueryChaincodeDefinition" function
      _lifecycle/QueryChaincodeDefinition: /Channel/Application/Readers

      # ACL policy for _lifecycle's "QueryChaincodeDefinitions" function
      _lifecycle/QueryChaincodeDefinitions: /Channel/Application/Readers

      #---Lifecycle System Chaincode (lscc) function to policy mapping for access control---#

      # ACL policy for lscc's "getid" function
      lscc/ChaincodeExists: /Channel/Application/Readers

      # ACL policy for lscc's "getdepspec" function
      lscc/GetDeploymentSpec: /Channel/Application/Readers

      # ACL policy for lscc's "getccdata" function
      lscc/GetChaincodeData: /Channel/Application/Readers

      # ACL Policy for lscc's "getchaincodes" function
      lscc/GetInstantiatedChaincodes: /Channel/Application/Readers

      #---Query System Chaincode (qscc) function to policy mapping for access control---#

      # ACL policy for qscc's "GetChainInfo" function
      qscc/GetChainInfo: /Channel/Application/Readers

      # ACL policy for qscc's "GetBlockByNumber" function
      qscc/GetBlockByNumber: /Channel/Application/Readers

      # ACL policy for qscc's  "GetBlockByHash" function
      qscc/GetBlockByHash: /Channel/Application/Readers

      # ACL policy for qscc's "GetTransactionByID" function
      qscc/GetTransactionByID: /Channel/Application/Readers

      # ACL policy for qscc's "GetBlockByTxID" function
      qscc/GetBlockByTxID: /Channel/Application/Readers

      #---Configuration System Chaincode (cscc) function to policy mapping for access control---#

      # ACL policy for cscc's "GetConfigBlock" function
      cscc/GetConfigBlock: /Channel/Application/Readers

      # ACL policy for cscc's "GetConfigTree" function
      cscc/GetConfigTree: /Channel/Application/Readers

      # ACL policy for cscc's "SimulateConfigTreeUpdate" function
      cscc/SimulateConfigTreeUpdate: /Channel/Application/Readers

      #---Miscellanesous peer function to policy mapping for access control---#

      # ACL policy for invoking chaincodes on peer
      peer/Propose: /Channel/Application/Writers

      # ACL policy for chaincode to chaincode invocation
      peer/ChaincodeToChaincode: /Channel/Application/Readers

      #---Events resource to policy mapping for access control###---#

      # ACL policy for sending block events
      event/Block: /Channel/Application/Readers

      # ACL policy for sending filtered block events
      event/FilteredBlock: /Channel/Application/Readers

{% endif %}
  Organizations:
{% if '2.' in network.version %}
  Policies: &ApplicationDefaultPolicies
    LifecycleEndorsement:
        Type: ImplicitMeta
        Rule: "MAJORITY Endorsement"
    Endorsement:
        Type: ImplicitMeta
        Rule: "MAJORITY Endorsement"
    Readers:
        Type: ImplicitMeta
        Rule: "ANY Readers"
    Writers:
        Type: ImplicitMeta
        Rule: "ANY Writers"
    Admins:
        Type: ImplicitMeta
        Rule: "MAJORITY Admins"
{% endif %}
  Capabilities:
    <<: *ApplicationCapabilities

Channel: &ChannelDefaults
{% if '2.' in network.version %}
  Policies:
    Readers:
      Type: ImplicitMeta
      Rule: "ANY Readers"
    Writers:
      Type: ImplicitMeta
      Rule: "ANY Writers"
    Admins:
      Type: ImplicitMeta
      Rule: "MAJORITY Admins"
{% endif %}
  Capabilities:
    <<: *ChannelCapabilities

Organizations:

