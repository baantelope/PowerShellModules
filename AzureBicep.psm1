

function Create-AppService  {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $Subscription,

        [Parameter(Mandatory=$true)]
        [string]
        $resourceGroup,

        [Parameter(Mandatory=$true)]
        [string]
        $deploymentName,
        
        [Parameter(Mandatory=$true)]
        [string[]]
        $applicationName,

        [string]
        $applicationInsights,

        [Parameter(Mandatory=$true)]
        [string]
        $appServicePlan,

        [switch]
        $doNotMonitorApp,

        [ValidateSet("v3.0","v4.0","v5.0","v6.0")]
        $netFrameworkVersion = "v5.0",

        [ValidateSet("dotnet", "dotnetcore")]
        $dotNetType = "dotnet",

        [string]
        $vNetName = '',

        [string]
        $subnetName,

        [bool]
        $use32Bit = $true


    )

    Set-AzContext -Subscription $Subscription | Out-Null

    if($dotNetType -eq "dotnetcore")
    {
        $netFrameworkVersion = "v3.0"
    }
     
    foreach($appName in $applicationName)
    {
        if($doNotMonitorApp)
        {
            New-AzResourceGroupDeployment -Name $deploymentName -ResourceGroupName $resourceGroup -TemplateFile "E:\Bicep\AppServiceNoAI.bicep" -appName $appName -aspName $appServicePlan -netFrameworkVersion $netFrameworkVersion `
            -dotnettype $dotNetType -vNetName $vNetName -subnetName $subnetName -use32bit $use32Bit
        }
        else {
            New-AzResourceGroupDeployment -Name $deploymentName -ResourceGroupName $resourceGroup -TemplateFile "E:\Bicep\AppService.bicep" -appName $appName -aiName $applicationInsights -aspName $appServicePlan -netFrameworkVersion $netFrameworkVersion `
            -dotnettype $dotNetType -vNetName $vNetName -subnetName $subnetName -use32bit $use32Bit
        }
        
    }    
}

Export-ModuleMember -Function Create-AppService