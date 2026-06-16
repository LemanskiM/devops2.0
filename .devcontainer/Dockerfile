# Use official lightweight Ubuntu image as base
FROM ubuntu:22.04

# Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install core system tools and dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    ca-certificates \
    openssh-client \
    sudo \
    gnupg \
    lsb-release \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 1. Prawilny DevOps Install: Direct Download via curl inside the container
RUN curl -LO https://releases.hashicorp.com/terraform/1.9.5/terraform_1.9.5_linux_amd64.zip \
    && unzip terraform_1.9.5_linux_amd64.zip \
    && mv terraform /usr/local/bin/ \
    && rm terraform_1.9.5_linux_amd64.zip

# 2. Install Azure CLI (Official stable script address)
RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg \
    && install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/ \
    && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" \
    > /etc/apt/sources.list.d/azure-cli.list \
    && apt-get update \
    && apt-get install -y azure-cli \
    && rm microsoft.gpg

# 3. Install Kubectl (Direct stable version download)
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
    && rm kubectl

# 4. Install Helm (Direct stable version download)
RUN curl -LO https://get.helm.sh/helm-v3.14.4-linux-amd64.tar.gz \
    && tar -xzf helm-v3.14.4-linux-amd64.tar.gz \
    && mv linux-amd64/helm /usr/local/bin/helm \
    && rm -rf helm-v3.14.4-linux-amd64.tar.gz linux-amd64

# 5. Install K9s (Direct absolute URL to stable 0.32.5 release)
RUN curl -LO https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_amd64.tar.gz \
    && tar -xzf k9s_Linux_amd64.tar.gz \
    && mv k9s /usr/local/bin/ \
    && chmod +x /usr/local/bin/k9s \
    && rm k9s_Linux_amd64.tar.gz

# Create a non-root user 'vscode' for safe development inside the container
RUN useradd -m vscode -s /bin/bash \
    && echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set working directory inside the container
WORKDIR /workspace

USER root

RUN useradd -m ML -s /bin/bash \
    && echo "ML ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ml \
    && chmod 0440 /etc/sudoers.d/ml

RUN chown -R ML:ML /workspace

USER ML

CMD ["/bin/bash"]
