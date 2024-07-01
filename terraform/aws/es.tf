resource "aws_elasticsearch_domain" "monitoring-framework" {
  # Drata: Set [aws_elasticsearch_domain.node_to_node_encryption.enabled] to true to ensure secure protocols are being used to encrypt resource traffic. This setting ensures communication between OpenSearch cluster nodes is encrypted
  # Drata: Set [aws_elasticsearch_domain.domain_endpoint_options.enforce_https] to true to ensure secure protocols are being used to encrypt resource traffic
  # Drata: Set [aws_elasticsearch_domain.domain_endpoint_options.tls_security_policy] to Policy-Min-TLS-1-2-2019-07 to ensure security policies are configured using the latest secure TLS version
  # Drata: Set [aws_elasticsearch_domain.cluster_config.zone_awareness_enabled] to true to improve infrastructure availability and resilience
  # Drata: Set [aws_elasticsearch_domain.encrypt_at_rest.enabled] to true to ensure transparent data encryption is enabled
  domain_name           = "tg-${var.environment}-es"
  elasticsearch_version = "2.3"

  cluster_config {
    instance_type            = "t2.small.elasticsearch"
    instance_count           = 1
    dedicated_master_enabled = false
    dedicated_master_type    = "m4.large.elasticsearch"
    dedicated_master_count   = 1
  }


  ebs_options {
    ebs_enabled = true
    volume_size = 30
  }
  tags = {
    # Drata: Configure [aws_elasticsearch_domain.tags] to ensure that organization-wide tagging conventions are followed.
    git_commit           = "e6d83b21346fe85d4fe28b16c0b2f1e0662eb1d7"
    git_file             = "terraform/aws/es.tf"
    git_last_modified_at = "2023-04-27 12:47:51"
    git_last_modified_by = "nadler@paloaltonetworks.com"
    git_modifiers        = "nadler/nimrodkor"
    git_org              = "bridgecrewio"
    git_repo             = "terragoat"
    yor_trace            = "95131dec-d7c9-49bb-9aff-eb0e2736603b"
  }
}

data aws_iam_policy_document "policy" {
  statement {
    actions = ["es:*"]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    resources = ["*"]
  }
}

resource "aws_elasticsearch_domain_policy" "monitoring-framework-policy" {
  domain_name     = aws_elasticsearch_domain.monitoring-framework.domain_name
  access_policies = data.aws_iam_policy_document.policy.json
}
