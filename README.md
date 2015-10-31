Patroni for Cloud Foundry
=========================

Background
----------

### registrator job

This is running a fork of gliderlabs/registrator https://github.com/drnic/registrator/tree/hostname-override that allows use to set the `-hostname` used in the registration. This means we can use BOSH VM information; rather than generic IaaS hostname info. This is especially good for bosh-lite vms which share the same common `hostname`.

Usage
-----

To directly target a Patroni/Docker node's broker and create a container:

```
id=1; broker=10.244.22.6; curl -v -X PUT http://containers:containers@${broker}/v2/service_instances/${id} -d '{"service_id": "0f5c1670-6dc3-11e5-bc08-6c4008a663f0", "plan_id": "1545e30e-6dc3-11e5-826a-6c4008a663f0", "organization_guid": "x", "space_guid": "x"}' -H "Content-Type: application/json"
```

To create replica container on another vm `10.244.22.7`:

```
id=1; broker=10.244.22.7; curl -v -X PUT http://containers:containers@${broker}/v2/service_instances/${id} -d '{"service_id": "0f5c1670-6dc3-11e5-bc08-6c4008a663f0", "plan_id": "1545e30e-6dc3-11e5-826a-6c4008a663f0", "organization_guid": "x", "space_guid": "x"}' -H "Content-Type: application/json"
```

To confirm that the first container is the leader:

```
$ ./scripts/leaders.sh
cf-1 postgres:// replicator replicator 10.244.22.6 32768 postgres
```

Note that `id=1` has become `cf-1`.

Create more container clusters with different `id=123` and you'll see the first container created is the leader.
