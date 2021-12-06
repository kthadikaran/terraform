# terraform
Terraform is a tool for building, changing, and versioning infrastructure safely and efficiently. Terraform can manage existing and popular cloud service providers like AWS, Azure, GCP as well as custom in-house solutions.

IaC makes it easy to provision and apply infrastructure configurations, saving time and standardizing the different infrastructure.

Configuration files describe to Terraform the components needed to run a single application or your entire datacenter. 
Terraform generates an execution plan describing what it will do to reach the desired state, and then executes it to build the described infrastructure.

The infrastructure Terraform can manage includes low-level components such as compute instances, storage, and networking, as well as high-level components such as DNS entries, SaaS features, etc.

The key features of Terraform are:

**Infrastructure as Code:**
Infrastructure is described using a high-level configuration syntax. This allows a blueprint of your datacenter to be versioned and treated as you would any other code. Additionally, infrastructure can be shared and re-used.

**Execution Plans:**
Terraform has a "planning" step where it generates an execution plan. The execution plan shows what Terraform will do when you call apply. This lets you avoid any surprises when Terraform manipulates infrastructure.

**Resource Graph:**
Terraform builds a graph of all your resources, and parallelizes the creation and modification of any non-dependent resources. Because of this, Terraform builds infrastructure as efficiently as possible, and operators get insight into dependencies in their infrastructure.

**Change Automation:**
Complex changesets can be applied to your infrastructure with minimal human interaction

**Install terraform on Ubuntu 20.04**

Terraform is available in two form binary file and you can install it from repository.

Download the latest version of Terrafrom. At the time of writing article, the latest version is 0.14.3

$ wget https://releases.hashicorp.com/terraform/0.14.3/terraform_0.14.3_linux_amd64.zip

$ sudo apt install zip -y

$ sudo unzip terraform_0.14.3_linux_amd64.zip

$ sudo mv terraform /usr/local/bin/ or $ sudo mv terraform /usr/bin/

$ terraform version

**Repository confiuration**

Terraform also offering package repositories for Debian and Ubuntu systems, which allow you to install Terraform using the apt install command or any other APT frontend.

$curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

$sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

$sudo apt install terraform

$ which terraform

/usr/bin/terraform

$ terraform --version

Terraform v0.14.7

The above command line uses the following sub-shell commands:

dpkg --print-architecture to determine your system's primary APT architecture/ABI, such as amd64.

lsb_release -cs to find the distribution release codename for your current system, such as buster, groovy, or sid.

apt-add-repository usually automatically runs apt update as part of its work in order to fetch the new package indices, but if it does not then you will need to so manually before the packages will be available.

For RedHat Enterprise Linux, Fedora, and Amazon Linux systems, which allow you to install Terraform using the yum install or dnf install commands.

$sudo yum install -y yum-utils

$sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/$release/hashicorp.repo

$sudo yum install terraform

**Install terraform on Windows10**

Chocolatey is a free and open-source package management system for Windows. Install the Terraform package from the command-line.

Step 1: Click start and type powershell
Step 2: Right click windows Powershell and choose "Run as Administrator"

Exceute the below commands

Set-ExecutionPolicy Bypass -Scope Process -Force;iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))  

choco install terraform  

terraform -help  
