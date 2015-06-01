HAProxy and Keepalived Demo
===========================

Demo showing how to setup redundant HAProxy servers to load-balance traffic between web servers.

Most of the setup is based on this blog post: [HAProxy and Keepalived: Example Configuration](http://andyleonard.com/2011/02/01/haproxy-and-keepalived-example-configuration/)

Setup:
------

There will be two load-balancer servers running [HAProxy](http://www.haproxy.org/) and [keepalived](http://keepalived.org/).

* **LB1** will have VRRP priority 101 and is the **master** load-balancer
* **LB2** will have VRRP priority 100 and is the **backup** load-balancer

Both LBs use round-robin algorithm to route traffic to Web1 and Web2 servers which run Nginx on port 80.

Steps:
-----

Create the 4 VMs:

    vagrant up

Test it out:

    # Hit web1-box directly
    curl http://192.168.33.68

    # Hit web2-box directly
    curl http://192.168.33.68

    # Hit vip
    curl http://192.168.33.84

See the HAProxy stats:

    LB 1: http://192.168.33.80/stats
    LB 2: http://192.168.33.81/stats

**In one terminal:**

    while true; do curl -sI http://192.168.33.84 | head -n 1; sleep 1; done
    # ==> HTTP/1.1 200 OK

**In a second terminal:**

    vagrant ssh lb-box1
    sudo tcpdump -i eth1

    # Look for VRRP advertisements.
    # Press CTRL+C

    sudo su
    echo show stat | socat /var/lib/haproxy/stats.sock stdio | grep http,BACKEND

    # Observe the http backend bytes out (column 10)
    # It should be going up

**In a third terminal:**

    vagrant ssh lb-box2
    sudo tcpdump -i eth1

    # Look for VRRP advertisements.
    # Press CTRL+C

    sudo su
    echo show stat | socat /var/lib/haproxy/stats.sock stdio | grep http,BACKEND

    # Observe the http backend bytes out (column 10)
    # It should be going not be going up

**In a fourth terminal:**

    vagrant halt lb-box1

The `curl` requests should continue via the vip but be routed to LB2.

Observe the http backend bytes out (column 10) in third terminal (lb-box2) - it should now be going up.

    vagrant up lb-box1

The `curl` requests should continue via the vip but be routed back to LB1.

Learning Resources:
-------------------

* [HAProxy and Keepalived: Example Configuration](http://andyleonard.com/2011/02/01/haproxy-and-keepalived-example-configuration/)
* [Keepalived and HAProxy in AWS: An Exploratory Guide]( https://blog.logentries.com/2014/12/keepalived-and-haproxy-in-aws-an-exploratory-guide/)
* [Making HAProxy High Available For MySQL Galera Cluster](http://www.fromdual.com/making-haproxy-high-available-for-mysql-galera-cluster)
* [Redundant Load Balancers – HAProxy and Keepalived](http://behindtheracks.com/2014/04/redundant-load-balancers-haproxy-and-keepalived/)
* [How To Use HAProxy to Set Up HTTP Load Balancing on an Ubuntu VPS]( https://www.digitalocean.com/community/tutorials/how-to-use-haproxy-to-set-up-http-load-balancing-on-an-ubuntu-vps)
* [Virtual Router Redundancy Protocol (VRRP)](http://en.wikipedia.org/wiki/Virtual_Router_Redundancy_Protocol)
* [HAProxy Architecture  Guide](http://www.haproxy.org/download/1.3/doc/architecture.txt)
* [keepalived User Guide](http://www.keepalived.org/pdf/UserGuide.pdf) [PDF]
