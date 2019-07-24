---
layout: default
title: Newly-minted Certified Kubernetes Administrator (CKA)
---

# Newly-minted Certified Kubernetes Administrator (CKA)

In July I became a CKA on my second attempt, improving my score from 67% to 79% (74% to pass).

A couple of people -- nerds, really -- asked me about it, so I thought I'd write down some of the things I picked up along the way.

## What worked

- Practice effect. I took the exam twice!
- Practical experience. Second time around, I really took the time to familiarize with `kubectl`, and at work I deployed a CI/CD integration with my cluster, and that helped for sure, too.
- Having an external display in portrait rotation, since you get one extra browser tab.

## What didn't work

- First time around, using only a low-res display.
- Ctrl-C/Ctrl-V to copy/paste does not work in the browser, I _think_ it's Ctrl-/Shift-Insert instead.

## General

`kubectl explain` is a life-saver: use it to explain (of course), what the level of indentation, as well as what type of value(s) is expected.

The [https://kubernetes.io/docs/reference/kubectl/cheatsheet/](https://kubernetes.io/docs/reference/kubectl/cheatsheet/) is a handy collection of tips; e.g.,

Don't waste time typing out `kubectl` in full -- just use your new `k` alias defined below, and please enable Tab auto-completion (of resource names):

```
echo "source <(kubectl completion bash)" >> ~/.bashrc
alias k=kubectl
complete -F __start_kubectl k
source ~/.bashrc
```

Don't waste time typing out manifest files; e.g., use `k run --generator=run-pod/v1 --image=foo --dry-run -o=yaml > foo.yaml`, it's far quicker to modify an existing manifest.

## Workloads

For standard, non-headless Services, a DNS name is created so it is not necessary to know _which_ Endpoints to use. But there is also Pods DNS, which I remember as the "dashed IP of a given Pod", followed by something like ".default.pod.cluster.local"; e.g., `192-168-1-39.default.pod.cluster.local`. See [https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/).

Two containers within the same Pod will not see the same filesystem unless they have the same named `volumeMounts` specification. See [https://kubernetes.io/docs/concepts/storage/volumes/](https://kubernetes.io/docs/concepts/storage/volumes/).

## Nodes

Swap must be disabled in order for `kubelet.service` to work correctly (e.g., `swapoff -a`). See [https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/).

It's possible to configure `kubelet` with Pod manifests (e.g., `/etc/kubernetes/manifests/`), but check if `--staticPodPath` is also defined. See [https://kubernetes.io/docs/tasks/administer-cluster/static-pod/](https://kubernetes.io/docs/tasks/administer-cluster/static-pod/).

To take a snapshot of your `etcd`, use `etcdctl snapshot save --endpoints= --cacert= --cert= --key=`, with the last 4 arguments having values specific to your cluster. See [https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/](https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/).

Carefully inspect the output of `systemctl status kubelet` if you're seeing a `NotReady` node, it might be because the 

## References

* [https://training.linuxfoundation.org/training/kubernetes-fundamentals/](https://training.linuxfoundation.org/training/kubernetes-fundamentals/)
* [https://www.manning.com/books/kubernetes-in-action](https://www.manning.com/books/kubernetes-in-action)
* [http://shop.oreilly.com/product/0636920064947.do](http://shop.oreilly.com/product/0636920064947.do)
