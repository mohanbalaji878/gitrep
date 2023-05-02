param vnetName string = 'myVNet'
param addressPrefix string = '10.0.0.0/16'
param subnet1Name string = 'subnet1'
param subnet1Prefix string = '10.0.1.0/24'
param subnet2Name string = 'subnet2'
param subnet2Prefix string = '10.0.2.0/24'
param adminUsername string = 'myadminuser'
param adminPassword string = 'Password@878'
param vmNamePrefix string = 'myvm'

resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: vnetName
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: subnet1Name
        properties: {
          addressPrefix: subnet1Prefix
        }
      }
      {
        name: subnet2Name
        properties: {
          addressPrefix: subnet2Prefix
        }
      }

      
    ]
  }
}
resource nic1 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: '${vmNamePrefix}1NIC'
  location: resourceGroup().location
  dependsOn: [
    vnet
  ]
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, subnet1Name)
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

resource vm1 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: '${vmNamePrefix}1'
  location: resourceGroup().location
  dependsOn: [
    vnet
  ]
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_DS1_v2'
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        createOption: 'fromImage'
      }
    }
    osProfile: {
      computerName: '${vmNamePrefix}1'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: resourceId('Microsoft.Network/networkInterfaces', '${vmNamePrefix}1NIC')
        }
      ]
    }
  }
}
resource nic2 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: '${vmNamePrefix}2NIC'
  location: resourceGroup().location
  dependsOn: [
    vnet
  ]
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig2'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, subnet2Name)
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}
resource vm2 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: '${vmNamePrefix}2'
  location: resourceGroup().location
  dependsOn: [
    vnet
  ]
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_DS1_v2'
    }
    storageProfile: {
      imageReference: {
        publisher: 'canonical'
        offer: '0001-com-ubuntu-server-focal'
        sku: '20_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        createOption: 'fromImage'
      }
    }
    osProfile: {
      computerName: '${vmNamePrefix}2'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: resourceId('Microsoft.Network/networkInterfaces', '${vmNamePrefix}2NIC')
        }
      ]
    }
  }
}



