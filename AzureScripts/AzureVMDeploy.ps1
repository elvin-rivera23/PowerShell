# Created by: Elvin Rivera
# Date Created: 11/22/2020

#Install-Module AzureRM

Import-Module AzureRM
Login-AzureRMAccount

function Provision-AzureVM {
    param ($VMName)

$ResourceGroup = "RG_Name"
$Location = "WestUS"
$VNet = "Org-VNET-Name"
$Subnet = "Infrastucture-Subnet"
$VMSize = "Standard_DS2"
$VMLocalAdminUser = "LocalAdminVM"
$VMLocalAdminSecurePW = ConvertTo-SecureString "Admin123" -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($VMLocalAdminUser, $VMLocalAdminSecurePW)
$NSG = "Infrastructure-NSG"


New-AzureRMVM `
-ResourceGroupName $ResourceGroup `
-Name $VMName `
-Credential $Credential `
-Location $Location `
-VirtualNetworkName $VNet `
-SubnetName $Subnet `
-AllocationMethod Dynamic `
-SecurityGroupName $NSG `
-Size $VMSize `
-ImageName win2016Datacenter
    
}

$VMs = @(
"VM1-DB"
"VM2-Web"
"VM3-App"
)

foreach($VM in $VMs){
Provision-AzureVM -VMName $VM
}
