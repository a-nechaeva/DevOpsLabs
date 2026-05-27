#!/bin/bash

export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN='myroot'


vault secrets enable -path=secret kv-v2

vault kv put secret/cicd/lab4 \
    api_key="vault-super-secret-key-12345" \
    db_password="vault-secure-password-67890" \
    deploy_token="vault-deploy-token-abcdef"


vault policy write cicd-policy vault/policies/cicd-policy.hcl

vault auth enable approle

vault write auth/approle/role/cicd-role \
    token_policies="cicd-policy" \
    token_ttl=1h \
    token_max_ttl=4h

ROLE_ID=$(vault read -field=role_id auth/approle/role/cicd-role/role-id)
SECRET_ID=$(vault write -field=secret_id -f auth/approle/role/cicd-role/secret-id)
