# hetzner-pearson-cka-cluster

Unofficial Terraform/Ansible project to provision and set up servers for the labs and sample exams of Pearson's
[Certified Kubernetes Administrator (CKA) specialization](https://www.coursera.org/specializations/certified-kubernetes-administrator)
on Coursera.

The course expects you to prepare the lab machines yourself. This project does that on
[Hetzner Cloud](https://www.hetzner.com/cloud). You get the nodes of the course's sample exams, prepared up to the point
where the actual exam task begins (`kubeadm init`).

> **Note:** This project is not affiliated with Pearson, Coursera or the course author. Hetzner servers and load
> balancers cost money for as long as they exist. Run `terraform destroy` when you are done.

> **Sample exam notes:** [`NOTES_SAMPLE_EXAMEN.md`](NOTES_SAMPLE_EXAMEN.md) lists where the sample exam tasks and
> their grading scripts disagree. Worth a read even if you don't use this project.

## What you get

Two cluster layouts from the course:

| `exam`  | Nodes                                          | Load balancer                                   |
|---------|------------------------------------------------|-------------------------------------------------|
| `exam1` | `control1`, `control2`, `control3`, `worker1`, `worker2` | Hetzner LB on port 6443 in front of the control nodes (HA cluster) |
| `exam2` | `control`, `worker1`, `worker2`                | none                                            |

What Terraform does:
- creates the servers and, for `exam1`, the load balancer.

What Ansible then does on every node:
- upgrades Ubuntu and sets up the kernel modules and sysctls Kubernetes needs
- writes `/etc/hosts` entries for all nodes
- creates the user `student` with passwordless sudo, the same as in the course and the exam. Your SSH key works for
  this user. From the first control node (`control1` or `control`), `student` can `ssh` to all other nodes without a
  password.
- clones the course repo [sandervanvugt/cka](https://github.com/sandervanvugt/cka) to `/home/student/cka`
- runs the course setup scripts (container runtime, kubetools)

On the control nodes only, it also:
- copies [`NOTES_SAMPLE_EXAMEN.md`](NOTES_SAMPLE_EXAMEN.md) into the home of `student`. It has notes on the sample
  exam tasks, mostly where a task and its grading script disagree.

On your own machine, it:
- writes a `README_EXAM-1.txt` or `README_EXAM-2.txt` into the root of this repo. It contains the SSH logins for every
  node and hints for the first exam task.
- adds the nodes' host keys to your `known_hosts`

## Requirements

- a [Hetzner Cloud](https://console.hetzner.cloud/) account
- [Terraform](https://developer.hashicorp.com/terraform/install)
- Python 3, used for Ansible in a virtualenv

## Quickstart

1. **Create a Hetzner Cloud project** in the [Hetzner Cloud Console](https://console.hetzner.cloud/).

2. **Create an API token.** In the project, go to *Security* → tab *API tokens* → *Generate API token* and give it
   *Read & Write* permissions. Put the token into your own `terraform.tfvars`:
   ```bash
   cp terraform/terraform.tfvars.example terraform/terraform.tfvars
   ```
   ```hcl
   hcloud_token = "<your token>"
   ```
   `terraform.tfvars` is in `.gitignore`. Never commit it.

3. **Create an SSH key** and add it to the project:
   ```bash
   ssh-keygen -t ed25519 -f ~/.ssh/cka-pearson -C cka-pearson
   cat ~/.ssh/cka-pearson.pub
   ```
   In the project, go to *Security* → tab *SSH keys* → *Add SSH key*, paste the public key and name it. Then enter
   that name and the local path of the private key in `terraform.tfvars`:
   ```hcl
   ssh_key_name         = "cka-pearson"
   default_ssh_key_path = "~/.ssh/cka-pearson"
   ```

4. **If your key has a passphrase,** load it into `ssh-agent` first. Otherwise Ansible can't use it:
   ```bash
   eval $(ssh-agent)
   ssh-add ~/.ssh/cka-pearson
   ```

5. **Adjust location and server type** (optional). In `terraform.tfvars` you can change `hcloud_location` and
   `server_type`. Not every server type is available at every location.

   The much cheaper `cx23` (*Cost-Optimized*) is the one you want, but Hetzner doesn't have it available every day.
   If `terraform apply` fails because of that, either try again later or switch to `cpx22` (*Regular Performance*):
   ```hcl
   server_type = "cx23"   # or "cpx22"
   ```
   <!-- TODO: add the exact error message terraform apply shows when cx23 is unavailable -->

   Keep `hcloud_node_image = "ubuntu-24.04"`. With `ubuntu-26.04` the course scripts currently run into version
   issues.
   <!-- TODO: fix or describe a workaround for ubuntu-26.04 -->


6. **Choose the exam layout** in `terraform.tfvars`:
   ```hcl
   exam = "exam1"   # or "exam2"
   ```
   If you switch on an existing setup, the nodes that aren't part of the new layout are destroyed and the new ones are
   created.

7. **Choose the Kubernetes version** (optional) in `ansible/group_vars/all/vars.yaml`:
   ```yaml
   course_kubetools_previousversion: true
   ```
   With `true` (default), the previous Kubernetes version is installed (`setup-kubetools-previousversion.sh`), so you
   can practice the cluster upgrade later. With `false`, the current version is installed (`setup-kubetools.sh`).

8. **Create the servers:**
   ```bash
   cd terraform
   terraform init
   terraform plan
   terraform apply
   ```

9. **Set up the nodes with Ansible:**
   ```bash
   cd ../ansible
   python3 -m venv .venv
   source .venv/bin/activate
   pip install ansible
   ansible-playbook 01_setup_cka_cluster.yaml
   ```
   The playbook reads the inventory from `terraform output` and adds the nodes' host keys to your `known_hosts`, so
   you don't need an inventory file.

10. **Log in.** The logins are in `README_EXAM-1.txt` or `README_EXAM-2.txt` in the repo root, for example:
    ```bash
    ssh -i ~/.ssh/cka-pearson student@<ip of control1>
    ```

## Tips

- Run a single step again with its tag, for example to only regenerate the README with the logins:
  ```bash
  ansible-playbook 01_setup_cka_cluster.yaml --tags access_readme
  ```
  The tags have the same names as the roles in `ansible/roles/`.
- To practice again from scratch, recreate the servers with `terraform destroy` and `terraform apply`, then run the
  playbook again.
- Remove everything with `terraform destroy` in `./terraform`.
