variable azure_subscription_id {
    type = string
    description = "Azure subscription id"
}

variable azure_client_id {
    type = string
    description = "Azure Client id"
}

variable azure_client_secret {
    type = string
    description = "Azure Client Secret"
}

variable azure_tenant_id {
    type = string
    description = "Azure tenant id"
}

variable ubuntuadminuser {
    type = string
    default = "ubuntu"
}

#Azure locations
variable "location"{
    type = string
    description = "Azure region where the resources will be created"
    default ="West US"
}
