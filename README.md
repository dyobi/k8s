
# Kubernetes Playground using Calico

> OS : Ubuntu/focal64

> Automated provisioning

<br/>

---

## Setup Prerequisites

> A working Vagrant setup using Vagrant + VirtualBox

> 8gb + ram & 6 + cpu cores

## Versions

> Ubuntu 20.04.6 LTS

> Containerd 1.6.14

> Kubernetes 1.30

> Calico 3.28.1

## Default Setting

> One master node & Two worker node

> Master Node IP : 172.16.16.100

> Worker Nodes IPs : 172.16.16.10#{i}

<br/>

---

## Bring Up the Cluster

Install all the packages and connect all nodes by one command 

```shell
git clone https://github.com/dyobi/k8s.git && cd k8s
```

```shell
vagrant up
```

## Vagrant SSH

To master node

```shell
vagrant ssh kmaster
```

To worker node1

```shell
vagrant ssh kworker1
```

To worker node2

```shell
vagrant ssh kworker2
```

<br/>

---

## Vagrant Global Status

```shell
vagrant global-status --prune
```

## Vagrant Shutdown

```shell
vagrant halt
```

## Vagrant Destroy

```shell
vagrant destroy -f
```
