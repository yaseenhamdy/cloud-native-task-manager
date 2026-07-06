data "http" "alb_controller_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json"
}


resource "aws_iam_policy" "alb_controller_policy" {
  name   = "AWSLoadBalancerControllerPolicy-${var.environment}"
  policy = data.http.alb_controller_policy.response_body
}