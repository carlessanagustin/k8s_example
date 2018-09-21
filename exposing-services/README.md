# Exposing services in kubernetes

([source](https://blog.getambassador.io/kubernetes-ingress-nodeport-load-balancers-and-ingress-controllers-6e29f1c44f2d))

## Methods

* [NodePort](https://kubernetes.io/docs/concepts/services-networking/service/#nodeport) - non production environments
* [Port Proxy](https://git.k8s.io/contrib/for-demos/proxy-to-service) - non production environments
* [LoadBalancer](https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer)
* [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)

> If you prefer [Helm](https://akomljen.com/package-kubernetes-applications-with-helm/), installation of the Nginx Ingress controller is easier.

## Definitions

* NodePort: A NodePort is an open port on every node of your cluster. A NodePort is assigned from a pool of cluster-configured NodePort ranges (typically 30000–32767).
* Port Proxy: Socat based container image (Socat is a command line based utility that establishes two bidirectional byte streams and transfers data between them)
* LoadBalancer: Using a LoadBalancer service type automatically deploys an external load balancer. The exact implementation of a LoadBalancer is **dependent on your cloud provider, and not all cloud providers support** the LoadBalancer service type. Moreover, **if you’re deploying Kubernetes on bare metal, you’ll have to supply your own load balancer implementation.**

```
        [ INTERNET ]
              |
  [ Cloud LoadBalancer + IP ]
         --|-----|--
       [ K8s Services ]
```

* Ingress: An ingress is a core concept (in beta) of Kubernetes, but is always implemented by a third party proxy. These implementations are known as ingress controllers. An ingress controller is responsible for reading the Ingress Resource information and processing that data accordingly. Different ingress controllers have extended the specification in different ways to support additional use cases.

```
        [ INTERNET ]
              |
[ External LoadBalancer + IP ]
             |
  [ K8s Ingress Controller ]
         --|-----|--
      [ K8s Services ]
```

## Ingress requirements: External Load Balancer:

* This load balancer will then route traffic to a Kubernetes service (or ingress) on your cluster that will perform service-specific routing. In this set up, your load balancer provides a stable endpoint (IP address) for external traffic to access.
* Choosing the right way to manage traffic from your external load balancer to your services. What are your options?
    * You can choose an ingress controller such as [ingress-nginx](https://github.com/kubernetes/ingress-nginx) or [NGINX kubernetes-ingress](https://github.com/nginxinc/kubernetes-ingress/).
    * You can choose an API Gateway deployed as a Kubernetes service such as [Ambassador](https://www.getambassador.io/) (built on [Envoy](https://www.envoyproxy.io/)) or [Traefik](http://traefik.io/).
    * You can deploy your own using a custom configuration of NGINX, HAProxy, or Envoy.

## How do you choose between an *ingress controller* and an *API gateway*?

Here are a few choices to consider:

* There are three different NGINX ingress controllers, with [different feature sets and functionality](https://github.com/nginxinc/kubernetes-ingress/blob/master/docs/nginx-ingress-controllers.md).
* [Traefik](http://traefik.io/) can [also be deployed as an ingress controller](https://docs.traefik.io/configuration/backends/kubernetes/), and exposes a subset of its functionality through Kubernetes annotations.
* Kong is a popular open source API gateway built on NGINX. However, because it supports [many infrastructure platforms](https://konghq.com/install/), it isn't optimized for Kubernetes. For example, Kong requires a database, when Kubernetes provides an excellent persistent data store in etcd. Kong also is configured via REST, while Kubernetes embraces declarative configuration management.
* [Ambassador](https://www.getambassador.io/) is built on the [Envoy Proxy](https://www.envoyproxy.io/), and exposes a [rich set of configuration options](https://www.getambassador.io/reference/mappings) for your services, as well as support for external authentication services.

### Kubernetes ingress with Ambassador

* [Ambassador](https://www.getambassador.io/) is an open source, Kubernetes-native API Gateway built on the [Envoy Proxy](https://www.datawire.io/envoyproxy/). Ambassador is easily configured via Kubernetes annotations, and supports all the use cases mentioned in this article. Deploy Ambassador to Kubernetes [in just a few simple steps](https://www.getambassador.io/user-guide/getting-started).

# Implementations

* [Tutorial: Kubernetes Nginx Ingress Controller](./KubernetesNginxIngressController)  - **OK**
* [Official: NGINX Ingress Controller](./ingress-nginx) - **UNTESTED**
* [Official: HAProxy Ingress Controller](./ingress-haproxy) - **UNTESTED**
* [Ingress controller Catalog](https://github.com/jcmoraisjr/ingress/blob/master/docs/catalog.md)
