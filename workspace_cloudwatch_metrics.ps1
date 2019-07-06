#Return Values from cloudwatch via PowerShell
$directory_id = <your_directory_id>

#Ref: https://docs.aws.amazon.com/sdkfornet/v3/apidocs/items/CloudWatch/TDimensionFilter.html
$dimension_filter = [Amazon.CloudWatch.Model.DimensionFilter]::new()
  $dimension_filter.Name = "DirectoryId"
  $dimension_filter.Value = $directory_id

#create a list from the available metrics 
$metric_list = Get-CWMetricList -Dimension $dimension_filter -Namespace AWS/WorkSpaces

#Ref: https://docs.aws.amazon.com/sdkfornet/v3/apidocs/items/CloudWatch/TDimension.html
$Dimension = [Amazon.CloudWatch.Model.Dimension]::new()
    $Dimension.Name = "DirectoryId"
    $Dimension.Value = $directory_id


foreach ($metric_name in $metric_list) 
  {
    "Returning statistics for {0}" -f $metric_name

    #Ref: https://docs.aws.amazon.com/sdkfornet/v3/apidocs/items/CloudWatch/TMetric.html
    $metric = [Amazon.CloudWatch.Model.Metric]::new()
        $metric.Dimensions = $Dimension
        $metric.MetricName = $metric_name
        #Namespaces are case sensitive, so we check it against available namespaces
        $metric.Namespace = "AWS/WorkSpaces"
            if ($metric.Namespace -notin ((Get-CWMetricList).Namespace | select -Unique) ) 
            {
            "metric Namespace {0} does not exist" -f $metric.Namespace    
        }
    
    #Ref: https://docs.aws.amazon.com/sdkfornet/v3/apidocs/items/CloudWatch/TMetricStat.html
    $metric_stat = [Amazon.CloudWatch.Model.MetricStat]::new()
        $metric_stat.Metric = $metric
        $metric_stat.Stat = "Average"
        $metric_stat.Period = 60
    
    #Ref: https://docs.aws.amazon.com/sdkfornet/v3/apidocs/items/CloudWatch/TMetricDataQuery.html
    $metric_data_query = [Amazon.CloudWatch.Model.MetricDataQuery]::new()
        $metric_data_query.MetricStat = $metric_stat
        $metric_data_query.Id = "info"

    $response = Get-CWMetricData -UtcStartTime 2019-07-5T22:00:00 -UtcEndTime 2019-07-5T23:59:00 -MetricDataQuery $metric_data_query | select *
    
    #only return a result with content
    if ($response.MetricDataResults.Values -ne $null)
      {
        $response
        $response.MetricDataResults.Values
      }
  }
