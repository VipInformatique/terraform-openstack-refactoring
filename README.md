# Terraform OpenStack VM Deployment Refactoring

> This project demonstrates the complete refactoring of a simple Terraform script into a robust, secure, and professional Infrastructure as Code (IaC) solution for deploying multiple OpenStack VMs based on a CSV file.

## 📖 Overview

The initial goal was to automate the deployment of virtual machines in an OpenStack/DevStack environment. I first developed a basic, functional script to achieve this.

Recognizing its limitations, I then performed a critical self-assessment and a full refactoring process. The mission was to transform my initial work into a production-ready solution by implementing DevOps and security best practices. This involved moving from a simple, insecure script to a reliable, secure, and fully reproducible automated workflow.

## ✨ Key Features & Improvements

This refactored solution implements a number of professional practices:

* **🔒 Secure Credential Management**: Sensitive data (passwords, URLs) is separated from the main code into a `secrets.tfvars` file, which is ignored by Git via `.gitignore`.
* **🤖 Automated SSH Key Management**: The script automatically imports public SSH keys into OpenStack from local files specified in the CSV, eliminating a manual pre-requisite step.
* **✅ Robust Validation**:
    * A precondition checks that the input `vm.csv` file is not empty before execution.
    * Data sources are used to verify that required resources (networks, security groups) exist in OpenStack before attempting to create any VMs.
* **⚙️ Controlled Execution Order**: Explicit dependencies (`depends_on`) are used to ensure resources are created in a logical and predictable order (validation -> key import -> VM creation).
* **📄 Clear Outputs**: An `outputs.tf` file is used to present a clean, readable summary of the created resources (VM IDs and IP addresses) upon successful completion.

## 🛠️ Technology Stack

* **Infrastructure as Code**: Terraform
* **Cloud Platform**: OpenStack (tested on a DevStack environment)
* **Execution Environment**: Ubuntu 22.04 LTS
* **Virtualization (for Host)**: VMware Workstation Pro

## 🚀 Getting Started

### Prerequisites

* An accessible OpenStack environment.
* Terraform installed on your local machine or bastion host.
* SSH key pairs generated locally.

### Configuration

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/VOTRE_NOM_UTILISATEUR/terraform-openstack-refactoring.git](https://github.com/VOTRE_NOM_UTILISATEUR/terraform-openstack-refactoring.git)
    cd terraform-openstack-refactoring
    ```

2.  **Configure your VMs:**
    * Edit the `vm.csv` file to define the virtual machines you want to create. Ensure the SSH key names correspond to key files that exist on your machine (e.g., `mykey` corresponds to `~/.ssh/mykey.pub`).

3.  **Set up your credentials:**
    * Create a `secrets.tfvars` file by copying the example:
        ```bash
        cp secrets.tfvars.example secrets.tfvars
        ```
    * Edit `secrets.tfvars` and fill in your actual OpenStack credentials. **This file should never be committed to Git.**

### Usage

1.  **Initialize Terraform:**
    ```bash
    terraform init
    ```

2.  **Plan the deployment:**
    * Terraform will check your code and the state of the infrastructure and show you what it's going to do.
    ```bash
    terraform plan -var-file="secrets.tfvars"
    ```

3.  **Apply the changes:**
    * This command will execute the plan and create the resources in OpenStack.
    ```bash
    terraform apply -var-file="secrets.tfvars"
    ```

## 📂 File Structure

.
├── .gitignore         # Specifies files to be ignored by Git (e.g., secrets, state files)
├── main.tf            # Main logic for creating resources (VMs, keys)
├── outputs.tf         # Defines the output data to display after execution
├── README.md          # This file
├── secrets.tfvars.example # An example file for user credentials
└── variables.tf       # Contains all variable declarations
└── vm.csv             # Input data file for VM definitions
