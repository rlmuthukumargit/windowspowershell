# Master OIDC Setup Guide: Azure Pipelines to AWS

This guide provides exhaustive, step-by-step instructions for configuring OpenID Connect (OIDC) between Azure DevOps and AWS.

---

## 1. Preparation: Gather Core Data
Identify your **Azure DevOps Organization ID** from Organization Settings > Overview.

---

## 2. Concept 1: Direct OIDC Setup

### Step 1: Create the AWS Identity Provider
- **Provider URL**: `https://vstoken.dev.azure.com/{ORG_ID}`
- **Audience**: `api://AzureADTokenExchange`

### Step 2: Create the Target Role
Create a role with a **Web Identity** trust relationship.
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "Federated": "arn:aws:iam::123456789012:oidc-provider/vstoken.dev.azure.com/{ORG_ID}" },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": { "vstoken.dev.azure.com/{ORG_ID}:aud": "api://AzureADTokenExchange" }
      }
    }
  ]
}
```

---

## 3. Concept 2: AWS STS Token Broker (Service Connection Native)

Use this pattern to separate your **Identity Role** from your **Task Role**. This is managed entirely within the Azure DevOps UI.

### Step 1: Configure Role B (Target Deployment Role)
Role B must trust Role A (the Identity Role).
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "AWS": "arn:aws:iam::123456789012:role/Role_A_Identity" },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

### Step 2: Configure Azure DevOps Service Connection
1. **New Service Connection** > **AWS**.
2. **Authentication Method**: Workload Identity Federation.
3. **Role to assume**: Enter the ARN of **Role B**.
4. **Use OIDC**: **Check this box**.

> **Note:** The AWS Toolkit extension automatically performs the OIDC exchange with Role A and then calls `sts:AssumeRole` for Role B before executing any pipeline tasks.

---

## 4. Troubleshooting
- **sts:AssumeRole Permission**: Ensure Role A has an inline policy allowing it to assume Role B.
- **Trust Relationships**: Double-check that Role B's trust policy explicitly lists Role A's ARN as a Principal.
