## DLT Platform 

### Common Components check

#### Common components check ( like flux, namespaces, service accounts, storage classes)
- Check for pods
        
        kubectl get pods -A
- Check for namespaces.

        kubectl get namespace
- Check for Storage Classes

        kubectl get sc
- Check for Service Accounts

        kubeclt get sa -A
        
- To describe the pod

        kubectl describe <pod name> -n <namespace>
- To check the logs of pod

        kubectl logs -c <container name in pod> <pod name> -n <namespace>


**NOTE:** The pods and other components take some time to setup.You can check the components while the retries occours.

#### Platform specific check

##### Fabric ( Specific components check like ca tools, ca server, orderer n peer)

Stage 1.
Check for flux pods using, kubectl get pods -A

    kubectl edit deployment/flux-{{ network.env.type }}
Check the branch details here if they are correct or not.

Stage 2.
Check for namespaces, service accounts and storage classes.
Check flux logs using 

    kubectl logs -f <flux pod name>

Possible errors, if namespaces, storege classes etc are not generated.
Value files are not properly generated or not properly pushed.
- Check whether git branch is right.
- Check whether the git credentials are right.

Stage 3. 
Check for ca-server.
Check if the pod is up and running.
If not, Check flux-helm operator  logs..
Possible errors
- Value files are not generated right. Release failed

Stage 4.
Check for orderer Pod.
Check if the pod is up and running.
If not, Check flux-helm operator logs..
Possible errors
- Value files are not generated right. Release failed

Stage 5.
Check for peers
Check if the pod is up and running.
If not, Check flux-helm operator logs..
Possible errors
- Value files are not generated right. Release failed
For further details check the pod logs or describe the helm release files

Stage 6.
Create channel/ Join channel
Check if pod is up and running, If not Check Flux logs
Possible errors:
- Error: failed to create deliver client: orderer client failed to connect to <url>:7050: failed to create new connection: context deadline exceeded

Not able to reach orderer, Check orderer logs for more details.
Backtrace it, check if ambassador is working 

- got unexpected status: BAD_REQUEST -- error authorizing update: error validating DeltaSet: policy for [Group] /Channel/Application not satisfied: Failed to reach implicit threshold of 1 sub-policies, required 1 remaining

The most common reasons for are:
a) This identity is not in the organization's administrator list.
b) The organization certificate is not effectively signed by the organization's CA chain.
c) The organization that the orderer does not know about identity.

Stage 8. 
Achor Peers

Check peer logs, filter results using grep "anchor"
If anchor peers are successful, you should find the list in the peer logs.
 
Stage 9.
Install Chaincode/ Instantiate Chaincode
Check Flux logs.
If Pod is not up and running backtrace to which component is creating issue.


**NOTE**:
If the components are not able to connect to each other, there could be some issue  with load balancer. Check the haproxy or external DNS logs for more debugging.

##### Final network validity check.
For fabric
For checking the logs of specific pods like orderer pod, peer pod or channel pods etc.
Get the list of pods using

    kubectl get pods -A

Copy the name of the pods from the list. 

    kubectl logs <pod name> -n <namespace>

To check the logs of a particular container inside the pod.

    kubectl logs -c <container name> <pod name> -n <namespace>

For checking the anchors peers

     kubectl logs <pod name> -n <namespace> | grep anchor
The output should have the list of the anchor peers.

For final checking of the validity of the fabric network.

1. Create a cli pod for any organization.Use this sample template. 


    metadata:
      namespace: <namespace>
      images:
        fabrictools: hyperledger/fabric-tools:2.0
        alpineutils: index.docker.io/hyperledgerlabs/alpine-utils:1.0
    storage:
      class: <storage class name>
      size: 256Mi
    vault:
      role: vault-role
      address: <vault address>
      authpath: <auth path>
      adminsecretprefix: <Path to admin secret Prefix>
      orderersecretprefix: <Path to orderer secret prefix>
      serviceaccountname: <Service account name>
      imagesecretname: regcred
      tls: false
    peer:
      name: <peer name>
      localmspid: <msp id of peer>
      tlsstatus: true
      address: <peer address>
    orderer:
      address: <orderer address>

2. To install the cli.


    helm install -f cli.yaml <chart path> -n <namespace>

3. Get the cli pod.

    
    kubectl get pod -n <namespace>

4. Copy the cli pod name from the output list and enter the cli using.

    
    kubectl exec -it <cli pod name> -n <namespace> -- bash
    
5. To see which chaincodes are installed 


    peer chaincode list --installed

6. Execute a transaction

For init:

        peer chaincode invoke -o <orderer url> --tls true --cafile <path of orderer tls cert> -C <channel name> -n <chaincode name> -c '{"Args":["init",""]}'
Upon successful invocation, should display a `status 200` msg.
