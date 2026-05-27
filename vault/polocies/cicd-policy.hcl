# Policy for CI/CD pipeline - read only access
path "secret/data/cicd/lab4" {
  capabilities = ["read"]
}

path "secret/data/cicd/*" {
  capabilities = ["deny"]
}