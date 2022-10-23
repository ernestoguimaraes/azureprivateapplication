# Enterprise Function APP in Terraform
This IaC (Infrastructure as Code) sample is a start point to your projects that implements a Azure Function App ready to Host a Python Application. It´s called Enterprise because usually, when working to Enterprise business, some non-function requirements come to top of discussion:

## The connectivity should be private

All resources should use internal network, private endpoints to guarantee my access isolation. This IaC depploys VNETs and Private Endpoint. 

## The resource must access only what is nedded

One function should have enough permission to access the data, using the least privilege access. The sample Function App can access the storage and Key Vault using Managed Identities and the code adds only the required permission to manage blobs or retrieve Secrets (*Storage Blob Data Contributor* and *Key Vault Secrets Officer*)

----------------

## Requirements

The function app needs to access a Key Vault and Storage Account using managed identities and without public access.


## Code Details

This Terraform sample has the main components
|Component | Description  | 
--- | --- | 
|aad|Attributes permissions to the FunctionApp Managed Identity|
|app_insights|Deploys Application Insights so it can be user on Function App to track logs |
|app_services|Deploys and Application Plan and a linux Function App ready to receive a Python function |
|dns | Private endpoints needs to register the IP on Private DNS. This module deploys the necessary addresses to enable a private endpoint to blob, key vault and function app |
|key vault|Deploys a Key Vault |
|Networking| The networking elements |
|Storage| Deploys the storage for the Function App and a sample storage that the function might access in the future |
|Terraform| The main file used to call modules and pass parameters. |
