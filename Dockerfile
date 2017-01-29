FROM golang:alpine
MAINTAINER "Denver Williams <denver@ii.coop>"
ENV TERRAFORM_VERSION=0.8.5
ENV KUBECTL_VERSION=v1.5.2
ENV ARC=amd64

# Install AWS CLI + Deps 
RUN apk add --update git bash util-linux wget tar curl build-base jq python py-pip groff less && \
pip install awscli && \
	apk --purge -v del py-pip && \
	rm /var/cache/apk/*


#Install Kubectl
RUN wget -O /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_VERSION/bin/linux/$ARC/kubectl && \
chmod +x /usr/local/bin/kubectl

# Install Terraform 
ENV TF_DEV=true
WORKDIR $GOPATH/src/github.com/hashicorp/terraform
RUN git clone https://github.com/hashicorp/terraform.git ./ && \
    git checkout v${TERRAFORM_VERSION} && \
    /bin/bash scripts/build.sh
WORKDIR $GOPATH

# Install CFSSL
RUN go get -u github.com/cloudflare/cfssl/cmd/cfssl && \
#Add Terraform Modules
go get -u github.com/cloudflare/cfssl/cmd/...

WORKDIR /home/terraform
COPY AddOns /home/terraform/AddOns
COPY Demo /home/terraform/Demo
COPY makefiles /home/terraform/makefiles
COPY modules /home/terraform/modules
COPY scripts /home/terraform/scripts
COPY test /home/terraform/test
COPY io.tf Makefile modules.tf modules_override.tf vpc-existing.tfvars entrypoint.sh /home/terraform/
RUN chmod +x /home/terraform/entrypoint.sh

#CMD ["/bin/bash"]
ENTRYPOINT ["/home/terraform/entrypoint.sh"]
