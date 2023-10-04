# terraform-lxd

A Terraform module for [Linux Containers](https://github.com/canonical/lxd/)
(LXD) utilizing
[terraform-provider-lxd](https://github.com/terraform-lxd/terraform-provider-lxd).

## Description

The module allows creating and provisioning instance fleets using
different mechanisms after implementing a manageable underlying infrastructure.

It is composed of two modules actually:

* `lxd-common`: creates a storage pool, a volume and an installation image. The
module call was appended to `provider.tf` for the sake of simplicity.
* `kvm`: runs per instance (or instance group) and adds volumes, prepares the
cloud-init image/s, renders the required templates and creates the instances.

## Requirements

### A host server

A preconfigured host server prepared for LXD. During development I put
together an Ansible playbook available from
[ansible-host-server](https://github.com/jordibalcellss/ansible-host-server/)
and tested under CentOS 7.

### Terraform

[Terraform](https://www.terraform.io/) manual installation is quite
straightforward

```
wget https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_amd64.zip
unzip terraform_1.5.7_linux_amd64.zip
sudo mv terraform /usr/local/bin/terraform
```

## Configuration

`main.tf` holds the specification for our deployment. The files under
`examples/` can be renamed and used to that purpose straight away.

### Input variables

| Name | Type | Description | Default |
| - | - | - | - |
| hostname | `string` | | `guest` |
| domain | `string` | Search domain | `local` |
| memory | `string` | Memory in megabytes | `128MB` |
| vcpu | `number` | Number of virtual cores | `1` |
| method | `string` | Address assign method, eiher `static` or `dhcp` | `dhcp` |
| address | `string` | IP address in CIDR notation | `""` |
| gateway | `string` | Default gateway | `""` |
| dns_1 | `string` | Primary nameserver | `""` |
| dns_2 | `string` | Secondary nameserver | `""` |
| deploy_account | `string` | Deployment account username | `deploy` |
| deploy_account_pwd | `string` | Deployment account password | `""` |
| port | `number` | LXD daemon port | `""` |
| trust_pwd | `string` | LXD daemon trust password | `""` |
| host_server | `string` | Host server IP address | `""` |

### Implementing

The infrastructure can be planned, applied and destroyed by means of

```
terraform init
terraform plan
terraform apply -auto-approve
terraform destroy -auto-approve
```

During creation Terraform will use `cloud-init` to create a privileged
deployment account inside the instances and provide the SSH key found in
`keys/id_rsa.pub`, so as to prepare the guest systems to be accessed by
further provisioning systems.

## Examples

### Single statically addressed instance

```hcl
module "guest01" {
  source = "./lxd"
  depends_on = [module.common]
  image_fingerprint = "${module.common.image_fingerprint}"
  hostname = "guest01"
  method = "static"
  address = "10.12.0.111/24"
  gateway = "10.12.0.1"
}
```

### Multiple instances with random hostnames

```hcl
variable "instances" { default = 3 }

resource "random_string" "hostname" {
  length = 4
  special = false
  upper = false
  count = "${var.instances}"
}

module "guests" {
  source = "./lxd"
  depends_on = [module.common]
  image_fingerprint = "${module.common.image_fingerprint}"
  hostname = "${random_string.hostname[count.index].result}"
  count = "${var.instances}"
}
```

Which created three instances

```
[deploy@host ~]$ lxc list
+------+---------+--------------------+------+-----------+-----------+
| NAME |  STATE  |        IPV4        | IPV6 |   TYPE    | SNAPSHOTS |
+------+---------+--------------------+------+-----------+-----------+
| jisf | RUNNING | 10.12.0.234 (eth0) |      | CONTAINER | 0         |
+------+---------+--------------------+------+-----------+-----------+
| wpxk | RUNNING | 10.12.0.233 (eth0) |      | CONTAINER | 0         |
+------+---------+--------------------+------+-----------+-----------+
| xnch | RUNNING | 10.12.0.231 (eth0) |      | CONTAINER | 0         |
+------+---------+--------------------+------+-----------+-----------+
```

Please, browse the `examples/` folder for further scripts.

## References

* [terraform-lxd/lxd (Terraform Registry)](https://registry.terraform.io/providers/terraform-lxd/lxd/latest/docs/)
* [Canonical LXD documentation](https://documentation.ubuntu.com/lxd/en/latest/)
* [cloud-init](https://cloudinit.readthedocs.io/en/latest/reference/)
* [ruanbekker/terraform-lxd-example](https://github.com/ruanbekker/terraform-lxd-example/)
* [Managing LXC/LXD Linux Containers with Terraform](https://number1.co.za/managing-lxc-lxd-linux-containers-with-terraform/)

