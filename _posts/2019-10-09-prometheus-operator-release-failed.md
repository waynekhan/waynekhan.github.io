---
layout: default
title: Prometheus Operator release failed
---

## Prometheus Operator release failed

Lately I've been getting up-to-speed on Prometheus. That is, the `prometheus-operator` chart installed via `helm`:

```bash
NAME                            CHART VERSION   APP VERSION
stable/prometheus-operator      6.11.0          0.32.0
```

I'm seeing an error, though:

```bash
Error: release prometheus failed: rpc error: code = Canceled desc = grpc: the client connection is closing
```

The workaround for this, as Github user `cu12` has so kindly pointed out, is to disable admission webhook support (e.g., `--set prometheusOperator.admissionWebhooks.enabled=false`).

## References

- [https://github.com/helm/helm/issues/6130#issuecomment-537829666](https://github.com/helm/helm/issues/6130#issuecomment-537829666)
