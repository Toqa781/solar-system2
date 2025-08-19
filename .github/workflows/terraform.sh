name: solar system workflow

on:
    workflow_dispatch:
    push:
        branches:
            - 'feature-*'
            - main
jobs:
    terraform:
        name: terraform deployment
        runs-on: ubuntu-latest
        environment: production
        steps:
            - name: checkout
              uses: actions/checkout@v5

            - name: Configure AWS Credentials
              uses: aws-actions/configure-aws-credentials@v4.3.1
              with:
                aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
                aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
                aws-region: eu-central-1

            - name: HashiCorp - Setup Terraform
              uses: hashicorp/setup-terraform@v3.1.2
              with:
                terraform_version: "1.1.7"

            - name: terraform init
              run: terraform init
              working-directory: ./Terraform

            - name: terraform plan
              run: terraform plan
              working-directory: ./Terraform

            - name: terraform apply
              run: terraform apply -auto-approve

            # - name: terraform apply or destroy
            #   run: |
            #     if ["${{ github.events.inputs.destroy }}"="yes"]; then
            #     terraform destroy -auto-approve
            #     else
            #         terraform apply -auto-aprove
            #     fi
            #   working-directory: ./Terraform