# ElixirPlugPoc

Trivial example project to demonstrate the use of [Elixir Plug module](https://github.com/elixir-lang/plug).

## Running under docker (downloading from docker hub)

```
docker run -p 4000:4000 binarytemple/elixir_plug_poc:<version>
```

## Running under docker (build it locally)

```
docker build -t whatever .
docker run whatever
```


## Running under Kubernetes.

This is where it gets fancy, this will serve as a handly starting point for distributed Erlang under Kubernetes.

The file `k8s/deploy/elixir-plug-poc.yaml` describes a kubernetes statefulset and service.

When the file is applied to your kubernetes cluster, two pods will be created - with hostnames corresponding to the FQDN of the nodes.

```
kubectl apply -f k8s/elixir-plug-poc.yaml
```

```
kubectl exec -t -i elixir-plug-poc-0 /bin/bash
```

```
bash-4.4# hostname -f
elixir-plug-poc-0.elixir-plug-poc.default.svc.cluster.local
```

You can discover the other node names using a SRV or wildcard query after removing the first dot from the hostname i.e.

```
bash-4.4# dig *.elixir-plug-poc.default.svc.cluster.local

; <<>> DiG 9.12.4-P2 <<>> *.elixir-plug-poc.default.svc.cluster.local
;; global options: +cmd
;; Got answer:
;; WARNING: .local is reserved for Multicast DNS
;; You are currently testing what happens when an mDNS query is leaked to DNS
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 34261
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 4, AUTHORITY: 0, ADDITIONAL: 0

;; QUESTION SECTION:
;*.elixir-plug-poc.default.svc.cluster.local. IN        A

;; ANSWER SECTION:
*.elixir-plug-poc.default.svc.cluster.local. 30 IN A 10.1.0.55
*.elixir-plug-poc.default.svc.cluster.local. 30 IN A 10.1.0.57
*.elixir-plug-poc.default.svc.cluster.local. 30 IN A 10.1.0.59
*.elixir-plug-poc.default.svc.cluster.local. 30 IN A 10.1.0.60

;; Query time: 0 msec
;; SERVER: 10.96.0.10#53(10.96.0.10)
;; WHEN: Mon Jul 01 14:10:16 UTC 2019
;; MSG SIZE  rcvd: 125
```

Or SRV query :

```
bash-4.4# dig SRV elixir-plug-poc.default.svc.cluster.local

; <<>> DiG 9.12.4-P2 <<>> SRV elixir-plug-poc.default.svc.cluster.local
;; global options: +cmd
;; Got answer:
;; WARNING: .local is reserved for Multicast DNS
;; You are currently testing what happens when an mDNS query is leaked to DNS
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 50739
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 4, AUTHORITY: 0, ADDITIONAL: 4

;; QUESTION SECTION:
;elixir-plug-poc.default.svc.cluster.local. IN SRV

;; ANSWER SECTION:
elixir-plug-poc.default.svc.cluster.local. 30 IN SRV 10 25 0 elixir-plug-poc-3.elixir-plug-poc.default.svc.cluster.local.
elixir-plug-poc.default.svc.cluster.local. 30 IN SRV 10 25 0 elixir-plug-poc-0.elixir-plug-poc.default.svc.cluster.local.
elixir-plug-poc.default.svc.cluster.local. 30 IN SRV 10 25 0 elixir-plug-poc-1.elixir-plug-poc.default.svc.cluster.local.
elixir-plug-poc.default.svc.cluster.local. 30 IN SRV 10 25 0 elixir-plug-poc-2.elixir-plug-poc.default.svc.cluster.local.

;; ADDITIONAL SECTION:
elixir-plug-poc-3.elixir-plug-poc.default.svc.cluster.local. 30 IN A 10.1.0.60
elixir-plug-poc-0.elixir-plug-poc.default.svc.cluster.local. 30 IN A 10.1.0.55
elixir-plug-poc-1.elixir-plug-poc.default.svc.cluster.local. 30 IN A 10.1.0.57
elixir-plug-poc-2.elixir-plug-poc.default.svc.cluster.local. 30 IN A 10.1.0.59

;; Query time: 0 msec
;; SERVER: 10.96.0.10#53(10.96.0.10)
;; WHEN: Mon Jul 01 14:11:32 UTC 2019
;; MSG SIZE  rcvd: 275
```



Lets attach to the running Elixir application inside the container :

```
bin/elixir_plug_poc remote_console
```


And verify `:inet_res.nslookup` is working correctly :

```
iex(elixir_plug_poc@elixir-plug-poc-0.elixir-plug-poc.default.svc.cluster.local)32> :inet_res.nslookup('elixir-plug-poc.default.svc.cluster.
local', :any, :srv)
{:ok,
 {:dns_rec, {:dns_header, 1, true, :query, true, false, true, true, false, 0},
  [{:dns_query, 'elixir-plug-poc.default.svc.cluster.local', :srv, :any}],
  [
    {:dns_rr, 'elixir-plug-poc.default.svc.cluster.local', :srv, :in, 0, 30,
     {10, 25, 0, 'elixir-plug-poc-0.elixir-plug-poc.default.svc.cluster.local'},
     :undefined, [], false},
    {:dns_rr, 'elixir-plug-poc.default.svc.cluster.local', :srv, :in, 0, 30,
     {10, 25, 0, 'elixir-plug-poc-1.elixir-plug-poc.default.svc.cluster.local'},
     :undefined, [], false},
    {:dns_rr, 'elixir-plug-poc.default.svc.cluster.local', :srv, :in, 0, 30,
     {10, 25, 0, 'elixir-plug-poc-2.elixir-plug-poc.default.svc.cluster.local'},
     :undefined, [], false},
    {:dns_rr, 'elixir-plug-poc.default.svc.cluster.local', :srv, :in, 0, 30,
     {10, 25, 0, 'elixir-plug-poc-3.elixir-plug-poc.default.svc.cluster.local'},
     :undefined, [], false}
  ], [],
  [
    {:dns_rr, 'elixir-plug-poc-0.elixir-plug-poc.default.svc.cluster.local', :a,
     :in, 0, 30, {10, 1, 0, 55}, :undefined, [], false},
    {:dns_rr, 'elixir-plug-poc-1.elixir-plug-poc.default.svc.cluster.local', :a,
     :in, 0, 30, {10, 1, 0, 57}, :undefined, [], false},
    {:dns_rr, 'elixir-plug-poc-2.elixir-plug-poc.default.svc.cluster.local', :a,
     :in, 0, 30, {10, 1, 0, 59}, :undefined, [], false},
    {:dns_rr, 'elixir-plug-poc-3.elixir-plug-poc.default.svc.cluster.local', :a,
     :in, 0, 30, {10, 1, 0, 60}, :undefined, [], false}
  ]}}
```


Verify distributed Erlang working correctly:

    iex(elixir_plug_poc@elixir-plug-poc-0.elixir-plug-poc.default.svc.cluster.local)11> Node.connect(:'elixir_plug_poc@elixir-plug-poc-1.elixir-plug-poc.default.svc.cluster.local')
    true

    iex(elixir_plug_poc@elixir-plug-poc-0.elixir-plug-poc.default.svc.cluster.local)20> Node.list
    [:"elixir_plug_poc@elixir-plug-poc-1.elixir-plug-poc.default.svc.cluster.local"]

    iex(elixir_plug_poc@elixir-plug-poc-0.elixir-plug-poc.default.svc.cluster.local)25> Node.ping(:"elixir_plug_poc@elixir-plug-poc-1.elixir-plug-poc.default.svc.cluster.local")
    :pong





