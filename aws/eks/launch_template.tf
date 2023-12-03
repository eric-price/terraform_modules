locals {
  device_list = tolist(data.aws_ami.bottlerocket_image.block_device_mappings)
}

resource "aws_launch_template" "core" {
  name                    = "eks-core-${var.cluster_name}"
  disable_api_stop        = false
  disable_api_termination = false
  image_id                = data.aws_ami.bottlerocket_image.id
  instance_type           = var.core_node_type
  user_data = base64encode(templatefile("../../modules/aws/eks/files/node_config.toml.tftpl", {
    cluster_name     = aws_eks_cluster.cluster.name
    cluster_endpoint = aws_eks_cluster.cluster.endpoint
    cluster_ca_data  = aws_eks_cluster.cluster.certificate_authority[0].data
    nodegroup        = "core"
    ami_id           = data.aws_ami.bottlerocket_image.id
    })
  )

  block_device_mappings {
    device_name = local.device_list[0]["device_name"]

    ebs {
      delete_on_termination = true
      volume_size           = 5
      volume_type           = "gp3"
      encrypted             = true
    }
  }

  block_device_mappings {
    device_name = local.device_list[1]["device_name"]

    ebs {
      delete_on_termination = true
      volume_size           = var.core_node_volume_size
      volume_type           = "gp3"
      encrypted             = true
    }
  }

  metadata_options {
    http_tokens                 = "required"
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 2
    instance_metadata_tags      = "enabled"
  }

  # network_interfaces {
  #   security_groups = [aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id]
  # }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name                 = "eks-core-${var.cluster_name}"
      terraform            = true
      "eks:cluster-name"   = var.env
      "eks:nodegroup-name" = "core"
      platform             = "eks"
      env                  = var.env
    }
  }

  tag_specifications {
    resource_type = "volume"

    tags = {
      Name                 = "eks-core-${var.cluster_name}"
      terraform            = true
      "eks:cluster-name"   = var.env
      "eks:nodegroup-name" = "core"
      platform             = "eks"
      env                  = var.env
    }
  }

  # Comment out when updating node
  lifecycle {
    ignore_changes = [
      image_id,
      user_data
    ]
  }
}
