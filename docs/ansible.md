## Inventory and deployment-specific addressing

The example inventories in this repository use logical hostnames and do not require fixed IP addresses:

```yaml
all:
  children:
    lab_linux:
      children:
        debian:
          hosts:
            lab-debian01:
        rocky:
          hosts:
            lab-rocky01:
```

In environments where these names cannot be resolved through DNS, Ansible's `ansible_host` variable can specify the actual connection address while preserving the logical inventory name:

```yaml
all:
  children:
    lab_linux:
      hosts:
        lab-debian01:
          ansible_host: 10.20.30.11
        lab-rocky01:
          ansible_host: 10.20.30.12
```

Playbooks and limits continue to use the logical inventory name:

```bash
ansible-playbook playbooks/patch-linux.yml --limit lab-rocky01
```

while Ansible connects to the address specified by `ansible_host`.

Real infrastructure inventories may contain internal IP addresses, DNS names, site names, and other deployment-specific topology. These values should normally be maintained outside this public reference repository.

Possible deployment patterns include:

* DNS or dynamic inventory, requiring no `ansible_host` override.
* A private inventory file supplied by the deployment.
* A private internal Git repository containing environment inventory.
* A static inventory maintained in an automation controller such as Semaphore or AWX/AAP.

Credentials, private keys, passwords, tokens, and other secrets should never be stored in plaintext inventory files committed to this repository.
