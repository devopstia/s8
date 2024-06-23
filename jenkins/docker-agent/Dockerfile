# Use Ubuntu as base image
FROM ubuntu:latest

RUN apt-get update
RUN apt-get install -y curl 
RUN apt-get install -y wget 
RUN apt-get install -y vim 
RUN apt-get install -y git 
RUN apt-get install -y jq 
RUN apt-get install -y postgresql-client 
RUN apt-get install -y mariadb-client 
RUN apt-get install -y mysql-client 
RUN apt-get install -y unzip 
RUN apt-get install -y zip

# Install Terraform
RUN wget https://releases.hashicorp.com/terraform/1.0.0/terraform_1.0.0_linux_amd64.zip && \
    unzip terraform_1.0.0_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_1.0.0_linux_amd64.zip && \
    terraform --version

# Install kubectl
RUN curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.17.9/2020-08-04/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv kubectl /usr/local/bin/

# Install kubectx and kubens
RUN wget https://raw.githubusercontent.com/ahmetb/kubectx/master/kubectx && \
    wget https://raw.githubusercontent.com/ahmetb/kubectx/master/kubens && \
    chmod +x kubectx kubens && \
    mv kubectx kubens /usr/local/bin/

# Install Helm 3
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh && \
    helm version

# Install Terragrunt
RUN wget https://github.com/gruntwork-io/terragrunt/releases/download/v0.38.0/terragrunt_linux_amd64 && \
    mv terragrunt_linux_amd64 terragrunt && \
    chmod u+x terragrunt && \
    mv terragrunt /usr/local/bin/terragrunt && \
    terragrunt --version

# Install Packer
RUN wget https://releases.hashicorp.com/packer/1.7.4/packer_1.7.4_linux_amd64.zip -P /tmp && \
    unzip /tmp/packer_1.7.4_linux_amd64.zip -d /usr/local/bin && \
    chmod +x /usr/local/bin/packer && \
    packer --version

# Install ArgoCD agent
RUN wget https://github.com/argoproj/argo-cd/releases/download/v2.8.5/argocd-linux-amd64 && \
    chmod +x argocd-linux-amd64 && \
    mv argocd-linux-amd64 /usr/local/bin/argocd 

# Install Sonar Scanner
RUN sonar_scanner_version="5.0.1.3006" && \
    wget -q https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${sonar_scanner_version}-linux.zip && \
    unzip sonar-scanner-cli-${sonar_scanner_version}-linux.zip && \
    mv sonar-scanner-${sonar_scanner_version}-linux sonar-scanner && \
    rm -rf /var/opt/sonar-scanner || true && \
    mv sonar-scanner /var/opt/ && \
    rm -rf /usr/local/bin/sonar-scanner || true && \
    ln -s /var/opt/sonar-scanner/bin/sonar-scanner /usr/local/bin/ || true && \
    sonar-scanner -v

# Set vim as default text editor
RUN update-alternatives --set editor /usr/bin/vim.basic && \
    update-alternatives --set vi /usr/bin/vim.basic

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip && \
    rm -rf aws

# Set /bin/bash as the default command
CMD ["/bin/bash"]