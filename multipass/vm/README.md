# Build Cluster

## Generate RSA Key

Generate a default RSA key pair for passwordless SSH login to the generated VMs.

```shell
ssh-keygen -t rsa -b 4096 -N "" -f id_rsa
```

## Build Cluster

Run `build_cluster.sh` to build cluster.

```shell
cd multipass
./vm/build_cluster.sh 3 true true
```

- `instance_number` indicates the number of nodes to create within the cluster
- `is_replace_source` indicates whether the default sources.list needs to be replaced by the third-part mirror source
- `is_setup_standalone_metastore` indicates the metastore server(vm00) need to be created