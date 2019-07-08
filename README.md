# ElixirPlugPoc

This project started as a demo project for a talk at wework shoreditch in 2016 demonstrating CI/CD in Elxir with docker. 

It is now a testbed for deploying and monitoring clustered Elixir applications in Kubernetes - with Prometheus monitoring and Grafan metric display.

## Running under docker (downloading from docker hub)

```
docker run -p 4000:4000 binarytemple/is_it_up:<version>
```

## Running under docker (build it locally)

```
docker build -t whatever .
docker run whatever
```


## Running under Kubernetes.

This is where it gets fancy, this will serve as a handly starting point for distributed Erlang under Kubernetes.

The file `k8s/deploy/is-it-up.yaml` describes a kubernetes statefulset and service.

When the file is applied to your kubernetes cluster, two pods will be created - with hostnames corresponding to the FQDN of the nodes.

```
kubectl apply -f k8s/is-it-up.yaml
```

```
kubectl exec -t -i is-it-up-0 /bin/bash
```

```
bash-4.4# hostname -f
is-it-up-0.is-it-up.default.svc.cluster.local
```

You can discover the other node names using a SRV or wildcard query after removing the first dot from the hostname i.e.

```
bash-4.4# dig *.is-it-up.default.svc.cluster.local

; <<>> DiG 9.12.4-P2 <<>> *.is-it-up.default.svc.cluster.local
;; global options: +cmd
;; Got answer:
;; WARNING: .local is reserved for Multicast DNS
;; You are currently testing what happens when an mDNS query is leaked to DNS
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 34261
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 4, AUTHORITY: 0, ADDITIONAL: 0

;; QUESTION SECTION:
;*.is-it-up.default.svc.cluster.local. IN        A

;; ANSWER SECTION:
*.is-it-up.default.svc.cluster.local. 30 IN A 10.1.0.55
*.is-it-up.default.svc.cluster.local. 30 IN A 10.1.0.57
*.is-it-up.default.svc.cluster.local. 30 IN A 10.1.0.59
*.is-it-up.default.svc.cluster.local. 30 IN A 10.1.0.60

;; Query time: 0 msec
;; SERVER: 10.96.0.10#53(10.96.0.10)
;; WHEN: Mon Jul 01 14:10:16 UTC 2019
;; MSG SIZE  rcvd: 125
```

Or SRV query :

```
bash-4.4# dig SRV is-it-up.default.svc.cluster.local

; <<>> DiG 9.12.4-P2 <<>> SRV is-it-up.default.svc.cluster.local
;; global options: +cmd
;; Got answer:
;; WARNING: .local is reserved for Multicast DNS
;; You are currently testing what happens when an mDNS query is leaked to DNS
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 50739
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 4, AUTHORITY: 0, ADDITIONAL: 4

;; QUESTION SECTION:
;is-it-up.default.svc.cluster.local. IN SRV

;; ANSWER SECTION:
is-it-up.default.svc.cluster.local. 30 IN SRV 10 25 0 is-it-up-3.is-it-up.default.svc.cluster.local.
is-it-up.default.svc.cluster.local. 30 IN SRV 10 25 0 is-it-up-0.is-it-up.default.svc.cluster.local.
is-it-up.default.svc.cluster.local. 30 IN SRV 10 25 0 is-it-up-1.is-it-up.default.svc.cluster.local.
is-it-up.default.svc.cluster.local. 30 IN SRV 10 25 0 is-it-up-2.is-it-up.default.svc.cluster.local.

;; ADDITIONAL SECTION:
is-it-up-3.is-it-up.default.svc.cluster.local. 30 IN A 10.1.0.60
is-it-up-0.is-it-up.default.svc.cluster.local. 30 IN A 10.1.0.55
is-it-up-1.is-it-up.default.svc.cluster.local. 30 IN A 10.1.0.57
is-it-up-2.is-it-up.default.svc.cluster.local. 30 IN A 10.1.0.59

;; Query time: 0 msec
;; SERVER: 10.96.0.10#53(10.96.0.10)
;; WHEN: Mon Jul 01 14:11:32 UTC 2019
;; MSG SIZE  rcvd: 275
```



Lets attach to the running Elixir application inside the container :

```
bin/is_it_up remote_console
```


And verify `:inet_res.nslookup` is working correctly :

```
iex(is_it_up@is-it-up-0.is-it-up.default.svc.cluster.local)32> :inet_res.nslookup('is-it-up.default.svc.cluster.
local', :any, :srv)
{:ok,
 {:dns_rec, {:dns_header, 1, true, :query, true, false, true, true, false, 0},
  [{:dns_query, 'is-it-up.default.svc.cluster.local', :srv, :any}],
  [
    {:dns_rr, 'is-it-up.default.svc.cluster.local', :srv, :in, 0, 30,
     {10, 25, 0, 'is-it-up-0.is-it-up.default.svc.cluster.local'},
     :undefined, [], false},
    {:dns_rr, 'is-it-up.default.svc.cluster.local', :srv, :in, 0, 30,
     {10, 25, 0, 'is-it-up-1.is-it-up.default.svc.cluster.local'},
     :undefined, [], false},
    {:dns_rr, 'is-it-up.default.svc.cluster.local', :srv, :in, 0, 30,
     {10, 25, 0, 'is-it-up-2.is-it-up.default.svc.cluster.local'},
     :undefined, [], false},
    {:dns_rr, 'is-it-up.default.svc.cluster.local', :srv, :in, 0, 30,
     {10, 25, 0, 'is-it-up-3.is-it-up.default.svc.cluster.local'},
     :undefined, [], false}
  ], [],
  [
    {:dns_rr, 'is-it-up-0.is-it-up.default.svc.cluster.local', :a,
     :in, 0, 30, {10, 1, 0, 55}, :undefined, [], false},
    {:dns_rr, 'is-it-up-1.is-it-up.default.svc.cluster.local', :a,
     :in, 0, 30, {10, 1, 0, 57}, :undefined, [], false},
    {:dns_rr, 'is-it-up-2.is-it-up.default.svc.cluster.local', :a,
     :in, 0, 30, {10, 1, 0, 59}, :undefined, [], false},
    {:dns_rr, 'is-it-up-3.is-it-up.default.svc.cluster.local', :a,
     :in, 0, 30, {10, 1, 0, 60}, :undefined, [], false}
  ]}}
```


Verify distributed Erlang working correctly:

    iex(is_it_up@is-it-up-0.is-it-up.default.svc.cluster.local)11> Node.connect(:'is_it_up@is-it-up-1.is-it-up.default.svc.cluster.local')
    true

    iex(is_it_up@is-it-up-0.is-it-up.default.svc.cluster.local)20> Node.list
    [:"is_it_up@is-it-up-1.is-it-up.default.svc.cluster.local"]

    iex(is_it_up@is-it-up-0.is-it-up.default.svc.cluster.local)25> Node.ping(:"is_it_up@is-it-up-1.is-it-up.default.svc.cluster.local")
    :pong





