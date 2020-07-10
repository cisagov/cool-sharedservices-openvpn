# ------------------------------------------------------------------------------
# Create the IAM policy that allows all of the permissions necessary
# to provision OpenVPN in the Shared Services account.
# ------------------------------------------------------------------------------

data "aws_iam_policy_document" "provisionopenvpn_policy_doc" {
  # This policy needs to be more restricted, obviously
  statement {
    actions = [
      "*",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "provisionopenvpn_policy" {
  provider = aws.provision_sharedservices

  description = var.provisionopenvpn_policy_description
  name        = var.provisionopenvpn_policy_name
  policy      = data.aws_iam_policy_document.provisionopenvpn_policy_doc.json
}
