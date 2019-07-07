#Create a WorkSpace with a specified bundleID for user in directory.

#declare our Request and Property types to pass to our build request.
#ref: https://docs.aws.amazon.com/sdkfornet/v3/apidocs/items/WorkSpaces/TWorkspaceRequest.html
$wks_request =  [Amazon.WorkSpaces.Model.WorkspaceRequest]::new()
#ref: https://docs.aws.amazon.com/sdkfornet/v3/apidocs/items/WorkSpaces/TWorkspaceProperties.html
$wks_properties =  [Amazon.WorkSpaces.Model.WorkspaceProperties]::new()

#set the relevant properties from WorkspaceProperties
$wks_properties.RunningMode = "AUTO_STOP"
#An always on Workspace will fail if we try to declare a timeout, so use a if statement.
if ($wks_properties.RunningMode -eq "AUTO_STOP")
    {
        #Running mode must be in incriments of 60 or this will fail
        $wks_properties.RunningModeAutoStopTimeoutInMinutes = 120 
    }

#Workspace Request values
$wks_request.BundleId = "<bundle_id>"
$wks_request.DirectoryId = "<ws_directory>"
$wks_request.UserName = "<User>"
$wks_request.WorkspaceProperties = $wks_properties

$create_request = New-WKSWorkspace -Workspace $wks_request -Verbose 

if ($create_request.FailedRequests -ne "")
    {
        "WS Creation failed with Errorcode: {0} : {1}" -f $create_request.FailedRequests.ErrorCode, $create_request.FailedRequests.ErrorMessage
    }
