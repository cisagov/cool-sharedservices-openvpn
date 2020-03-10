# ------------------------------------------------------------------------------
# Attach to the ProvisionAccount role the IAM policy that allows
# provisioning of OpenVPN in the Shared Services account.
# ------------------------------------------------------------------------------

resource "aws_iam_role_policy_attachment" "provisionopenvpn_policy_attachment" {
  policy_arn = aws_iam_policy.provisionopenvpn_policy.arn
  role       = var.provisionaccount_role_name
}
