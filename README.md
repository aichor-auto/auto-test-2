# If you intend to try this demo project on AIchor, please fork it

# Smoke test with any Operator

This is an AIchor demo project for test purpose
 
## Goal

This project aims to replace `efficientnet`, `raytune` and `jax-demo` project for internal AIchor tests.
Benefits:
- Light and simple images to speedup the build phase.
- Ability to test all operators within a single AIchor project (this repo).

`Efficientnet`, `raytune` and `jax-demo` projects can take up to 40 minutes for the first build, which slows down the test process. With this `smoke-test-any-operator`, build time take 30 seconds for tf/jax and 80 seconds for ray.


## How to use it ?

You can find multiple premade manifests in the `manifests` dir. If you want to try jax operator for example, all you need to do is to copy it:

```bash
$ cp manifests/manifest.jax.sample.yaml manifest.yaml

# also works with
# cp manifests/manifest.ray.sample.yaml manifest.yaml
# cp manifests/manifest.tf.sample.yaml manifest.yaml

$ git add manifest.yaml
$ git commit -m "exp: eriment"
$ git push
```


### Configuration

The python script executed in the provides 3 configurable flags:

```bash
> python main.py --help
usage: main.py [-h] [--operator {ray,jax,tf}] [--sleep SLEEP] [--tb-write TB_WRITE]

AIchor Smoke test on any operator

optional arguments:
  -h, --help            show this help message and exit
  --operator {ray,jax,tf}
                        operator name
  --sleep SLEEP         sleep time in seconds
  --tb-write TB_WRITE   test write to tensorboar
```

- the `--operator` flag depend on the operator you are using
- the `--sleep` flag takes a number of seconds to sleep before existing
- the `--tb-write` flag takes a boolean, if True the script will write a text message to the tensorboard. The message is the commit message used to submit the experiment (`VCS_COMMIT_MESSAGE`).

You can edit these flags in the manifest at `spec.command`

## What is the script doing ?

### Ray

For the Ray operator the script connects to the ray cluster then it prints the list of connected nodes.

Example:
```
connected nodes: [{'NodeID': 'f400d0bcbcfb962ca0a7c04fcc032f102d74354a6752420a0f05907c', 'Alive': True, 'NodeManagerAddress': '10.68.4.227', 'NodeManagerHostname': 'experiment-3e21cd11-06c0-job-fwwhf', 'NodeManagerPort': 12346, 'ObjectManagerPort': 12345, 'ObjectStoreSocketName': '/tmp/ray/session_2023-07-21_02-29-33_623409_1/sockets/plasma_store', 'RayletSocketName': '/tmp/ray/session_2023-07-21_02-29-33_623409_1/sockets/raylet', 'MetricsExportPort': 49427, 'NodeName': '10.68.4.227', 'alive': True, 'Resources': {'job': 100000.0, 'CPU': 1.0, 'object_store_memory': 573291724.0, 'node:10.68.4.227': 1.0, 'memory': 1337680692.0}}, {'NodeID': '2e51bcd357b943254ef4e46ba95a1fc1254eeeb4ebb2b70da0af8565', 'Alive': True, 'NodeManagerAddress': '10.68.1.163', 'NodeManagerHostname': 'experiment-3e21cd11-06c0-worker-cpu-workers-k69r5', 'NodeManagerPort': 12346, 'ObjectManagerPort': 12345, 'ObjectStoreSocketName': '/tmp/ray/session_2023-07-21_02-29-33_623409_1/sockets/plasma_store', 'RayletSocketName': '/tmp/ray/session_2023-07-21_02-29-33_623409_1/sockets/raylet', 'MetricsExportPort': 62882, 'NodeName': '10.68.1.163', 'alive': True, 'Resources': {'CPU': 1.0, 'node:10.68.1.163': 1.0, 'memory': 1337697895.0, 'object_store_memory': 573299097.0, 'cpu-workers': 100000.0}}, {'NodeID': '6d9e6b9030085198cc7a3f758b0597e66bc7bfe3913d0cb52db08424', 'Alive': True, 'NodeManagerAddress': '10.68.4.226', 'NodeManagerHostname': 'experiment-3e21cd11-06c0-head-2zbwt', 'NodeManagerPort': 12346, 'ObjectManagerPort': 12345, 'ObjectStoreSocketName': '/tmp/ray/session_2023-07-21_02-29-33_623409_1/sockets/plasma_store', 'RayletSocketName': '/tmp/ray/session_2023-07-21_02-29-33_623409_1/sockets/raylet', 'MetricsExportPort': 56889, 'NodeName': '10.68.4.226', 'alive': True, 'Resources': {'memory': 1050965607.0, 'object_store_memory': 525482803.0, 'node:10.68.4.226': 1.0, 'head': 100000.0, 'CPU': 1.0}}, {'NodeID': '6d5cae1d0ddbec38d78030d4809b0cc2b3e5c91b87fceb714481ad46', 'Alive': True, 'NodeManagerAddress': '10.68.0.49', 'NodeManagerHostname': 'experiment-3e21cd11-06c0-worker-cpu-workers-zsvfs', 'NodeManagerPort': 12346, 'ObjectManagerPort': 12345, 'ObjectStoreSocketName': '/tmp/ray/session_2023-07-21_02-29-33_623409_1/sockets/plasma_store', 'RayletSocketName': '/tmp/ray/session_2023-07-21_02-29-33_623409_1/sockets/raylet', 'MetricsExportPort': 53548, 'NodeName': '10.68.0.49', 'alive': True, 'Resources': {'memory': 1336737383.0, 'cpu-workers': 100000.0, 'node:10.68.0.49': 1.0, 'CPU': 1.0, 'object_store_memory': 572887449.0}}]
```

### TF

For the TF operator the script prints the `TF_CONFIG` env var. Note that if  `spec.Worker.count: 1` then the `TF_CONFIG` env var shall not exist and script will print `None`:

Example:
```
tf_config: None
tf_config is None because worker count = 1
```

### Jax


for the Jax operator the script will print 3 env var inject by the operator:
- `JAXOPERATOR_COORDINATOR_ADDRESS`
- `JAXOPERATOR_NUM_PROCESSES`
- `JAXOPERATOR_PROCESS_ID`

Example:
```
coordinator address: 0.0.0.0:1234
num processes: 1
process id: 0
```
