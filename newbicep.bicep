resource vnet 'Microsoft.Network/virtualNetworks@2020-05-01' = {
  name: 'VNet'
  location: 'eastus2'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '192.168.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'subnet1'
        properties: {
          addressPrefix: '192.168.1.0/24'
        }
      }
      {
        name: 'subnet2'
        properties: {
          addressPrefix: '192.168.2.0/24'
        }
      }
    ]
  }
}

resource nic1 'Microsoft.Network/networkInterfaces@2020-05-01' = {
  name: 'Nic1'
  location: 'eastus2'
  dependsOn: [
    vnet
  ]
  properties: {
    ipConfigurations: [
      {
        name: 'myIpConfig'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', 'VNet', 'subnet1')
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

resource vm1 'Microsoft.Compute/virtualMachines@2020-06-01' = {
  name: 'myVM'
  location: 'eastus2'
  dependsOn: [
   nic1
  ]
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B1ls'
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '18.04-LTS'
        version: 'latest'
      }
      osDisk: {
        name: 'myVMosdisk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
    }
    osProfile: {
      computerName: 'myVM'
      adminUsername: 'mohan12'
      adminPassword: 'Password@878'
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: resourceId('Microsoft.Network/networkInterfaces', 'NIC1')
        }
      ]
    }
  }
}

resource nic2 'Microsoft.Network/networkInterfaces@2020-05-01' = {
  name: 'Nic2'
  location: 'eastus2'
  dependsOn: [
    vnet
  ]
  properties: {
    ipConfigurations: [
      {
        name: 'myIpConfig'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', 'VNet', 'subnet2')
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}
resource vm2 'Microsoft.Compute/virtualMachines@2020-06-01' = {
  name: 'VirM2'
  location: 'eastus2'
  dependsOn: [
   nic2
  ]
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B1ls'
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-datacenter'
        version: 'latest'
      }
      osDisk: {
        name: 'myOsDisk'
        createOption: 'FromImage'
      }
    }
    osProfile: {
      computerName: 'VirM2'
      adminUsername: 'balaji12'
      adminPassword: 'Password@878'
      windowsConfiguration: {
        provisionVMAgent: true
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: resourceId('Microsoft.Network/networkInterfaces', 'Nic2')
        }
      ]
    }
  }
}
