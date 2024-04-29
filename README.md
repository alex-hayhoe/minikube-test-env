Deployment of Stack

git clone https://github.com/alex-hayhoe/minikube-test-env

cd modules

define env variables in ./stack/dev.tfvars

terraform plan --state=dev --var-file=./stack/dev.tfvars

terraform apply --state=dev --var-file=./stack/dev.tfvars


Removal of Stack

terraform destroy


