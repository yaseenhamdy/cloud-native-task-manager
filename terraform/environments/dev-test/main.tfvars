cluster_name = "dev-test-cluster"
vpc_cidr     = "10.0.0.0/16"
public_subnet_cidrs = {
  public_1 = "10.0.1.0/24"
  public_2 = "10.0.2.0/24"
}
public_subnet_azs = {
  public_1 = "us-east-1a"
  public_2 = "us-east-1b"
}
private_subnet_cidrs = {
  private_1 = "10.0.3.0/24"
  private_2 = "10.0.4.0/24"
}
private_subnet_azs = {
  private_1 = "us-east-1a"
  private_2 = "us-east-1b"
}

k8s_namespaces = {
  "dev_namespace"  = "dev"
  "test_namespace" = "test"
}
