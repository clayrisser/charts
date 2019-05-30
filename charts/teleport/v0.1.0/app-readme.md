# teleport

> privileged access management for elastic infrastructure

## Usage

### Create User

* Run the following command from the pod

```sh
tctl users add <USERNAME> root
```

* Navigate to the link provided by the result of step 1


### Add Node

* Make sure port `3022` is open on the node

* Install `teleport` on the node by running the following commands

```sh
curl -L -o teleport.tar.gz https://get.gravitational.com/teleport-v3.2.4-linux-amd64-bin.tar.gz
tar -xzvf teleport.tar.gz
sudo teleport/install
```

* Run the folling command from the pod

```sh
tctl nodes add
```

* Copy the command provided by the result of step 2

* Run the copied command on the node
