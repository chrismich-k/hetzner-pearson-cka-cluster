# ==========================================================
# cluster layouts of the course's two sample exams
# ==========================================================

# switch between them with exam = "exam1" | "exam2" in terraform.tfvars.
# Switching on an existing cluster destroys the nodes that aren't part of
# the new layout (and the load balancer when going to exam2)
locals {
  exams = {
    # 3 control nodes behind the Hetzner load balancer, 2 workers
    exam1 = {
      primary_control_node = "control1"
      k8s_api_lb           = true
      cluster_nodes = {
        control1 = { role = "control" }
        control2 = { role = "control" }
        control3 = { role = "control" }
        worker1  = { role = "worker" }
        worker2  = { role = "worker" }
      }
    }

    # single control node, no load balancer needed
    exam2 = {
      primary_control_node = "control"
      k8s_api_lb           = false
      cluster_nodes = {
        control = { role = "control" }
        worker1 = { role = "worker" }
        worker2 = { role = "worker" }
      }
    }
  }

  cluster_nodes        = local.exams[var.exam].cluster_nodes
  primary_control_node = local.exams[var.exam].primary_control_node
  k8s_api_lb           = local.exams[var.exam].k8s_api_lb
}
