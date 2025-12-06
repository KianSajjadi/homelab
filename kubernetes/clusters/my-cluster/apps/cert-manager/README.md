# cert-manager HTTPS Setup

This directory contains the configuration for cert-manager to provide automated TLS certificate management using Let's Encrypt.

## Overview

cert-manager has been configured to replace the old `ca-lan` certificate resolver with proper Let's Encrypt certificates for your AWS domain.

## Setup Steps

### 1. Create AWS IAM User for Route53 DNS Validation

You need an AWS IAM user with permissions to manage Route53 DNS records for DNS-01 challenge validation.

#### Create IAM Policy

Create a policy named `cert-manager-route53` with the following permissions:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "route53:GetChange",
      "Resource": "arn:aws:route53:::change/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets",
        "route53:ListResourceRecordSets"
      ],
      "Resource": "arn:aws:route53:::hostedzone/*"
    },
    {
      "Effect": "Allow",
      "Action": "route53:ListHostedZonesByName",
      "Resource": "*"
    }
  ]
}
```

#### Create IAM User

1. Create an IAM user named `cert-manager`
2. Attach the `cert-manager-route53` policy
3. Create access keys and save them securely

### 2. Configure AWS Credentials Secret

Edit `aws-credentials-secret.yaml` and encrypt it with SOPS:

```bash
# First, update the file with your actual AWS credentials (unencrypted)
# Replace the placeholder values:
# - access-key-id: YOUR_AWS_ACCESS_KEY_ID
# - secret-access-key: YOUR_AWS_SECRET_ACCESS_KEY

# Then encrypt the file with SOPS
cd /home/kian/projects/homelab
sops -e -i kubernetes/clusters/my-cluster/apps/cert-manager/aws-credentials-secret.yaml
```

### 3. Update ClusterIssuer Configuration

Edit both ClusterIssuer files and update the following fields:

**In `clusterissuer-letsencrypt-staging.yaml` and `clusterissuer-letsencrypt-prod.yaml`:**

1. **Email**: Replace `your-email@example.com` with your actual email for Let's Encrypt notifications
2. **AWS Region**: Replace `us-east-1` with your AWS region
3. **DNS Zone**: Replace `example.com` with your actual domain name

### 4. Update Your Domain Names

Since you're currently using `.lan` domains internally, you have two options:

#### Option A: Use Your AWS Domain for External Access

Update your ingress hosts to use your AWS domain (e.g., `grafana.yourdomain.com` instead of `grafana.lan`). This allows Let's Encrypt to validate via HTTP-01 or DNS-01.

#### Option B: Keep .lan Domains with Self-Signed Certificates

If you want to keep `.lan` domains for internal use, you'll need to create a self-signed ClusterIssuer instead:

```yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: selfsigned-issuer
spec:
  selfSigned: {}
```

Then update ingresses to use `cert-manager.io/cluster-issuer: selfsigned-issuer`.

**Note:** Let's Encrypt cannot issue certificates for `.lan` domains as they are not publicly routable.

### 5. Deploy cert-manager

Once you've configured everything, commit and push your changes. Flux will automatically:

1. Install cert-manager via Helm
2. Create the ClusterIssuers
3. Deploy the AWS credentials secret (decrypted by SOPS)
4. Update all ingresses with TLS certificates

### 6. Verify Installation

Check cert-manager is running:

```bash
kubectl get pods -n cert-manager
```

Check ClusterIssuers are ready:

```bash
kubectl get clusterissuer
```

Check certificates are being issued:

```bash
kubectl get certificate -A
kubectl describe certificate <cert-name> -n <namespace>
```

## Certificate Issuers

- **letsencrypt-staging**: Use this for testing to avoid rate limits
- **letsencrypt-prod**: Use this for production certificates

Start with staging, then switch to prod once everything works.

## Troubleshooting

### Check Certificate Status

```bash
kubectl describe certificate <name> -n <namespace>
kubectl describe certificaterequest -n <namespace>
kubectl describe order -n <namespace>
kubectl describe challenge -n <namespace>
```

### Check cert-manager Logs

```bash
kubectl logs -n cert-manager deployment/cert-manager -f
```

### Common Issues

1. **DNS-01 validation fails**: Check AWS credentials and IAM permissions
2. **HTTP-01 validation fails**: Ensure ingress is publicly accessible
3. **Rate limits**: Use staging issuer for testing

## Migration from ca-lan

All references to the old `ca-lan` cert resolver have been removed:

- ✅ Grafana ingress updated
- ✅ Spoolman ingress updated
- ✅ Paintman ingress updated
- ✅ AdGuard ingress updated
- ✅ Homepage ingress updated
- ✅ Old ca-lan service removed from kube-system

## Next Steps

1. Encrypt AWS credentials with SOPS
2. Update ClusterIssuer configuration with your domain and email
3. Decide on domain strategy (.lan vs AWS domain)
4. Commit and push changes
5. Monitor certificate issuance
6. Switch from staging to prod issuer once validated
