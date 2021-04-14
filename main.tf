module "channel" {
  source    = "./nr_alert_channel"

  name      ="put your alert channel"
  channel_config = [{
    recipients = "put your mail"
    include_json_attachment = "1"
    type = "email"
  },
  {
    url = "put your webhook"
    channel = "put your channel"
    type = "slack"
  }
  ]

}
#
# Cluster Sample Alerts
#
# Cluster Memory
module "cluster-mem" {
  source          = "./nr_alert_condiction"

  nr_policy       = module.channel.nr_alert_policy_id
  condiction_type = "static"
  name		        =	"[${var.cluster_name}-${var.environment}]-mem-free"
  description	    =	"Mem Free Alert"
  value_function  = "single_value"
  violation_time_limit_seconds =	3600
  nqrl_query = "SELECT uniqueCount(entityId) * latest(memoryAvailableBytes) as 'Memory Available' FROM K8sNodeSample WHERE clusterName = '${var.cluster_name}-${var.environment}' "
  critical = [{ 
        operator              = "below"
        threshold             = "3"
        threshold_duration    = "600"
        threshold_occurrences = "ALL"
  }]
  warning = [{ 
        operator              = "below"
        threshold             = "7"
        threshold_duration    = "600"
        threshold_occurrences = "ALL"
  }]
 }

# # Cluster CPU
module "cluster-cpu" {
  source          = "./nr_alert_condiction"
  nr_policy       = module.channel.nr_alert_policy_id
  condiction_type = "static"
  name		        =	"[${var.cluster_name}-${var.environment}]-cpu-usage"
  description	    =	"Cluster CPU Usage"
  value_function  = "single_value"
  violation_time_limit_seconds =	3600
  nqrl_query = "SELECT uniqueCount(entityId) * latest(allocatableCpuCoresUtilization) as 'CPU' FROM K8sNodeSample WHERE clusterName = '${var.cluster_name}-${var.environment}' "
  critical = [{ 
        operator              = "above"
        threshold             = "90"
        threshold_duration    = "300"
        threshold_occurrences = "ALL"
  }]
  warning = [{ 
        operator              = "above"
        threshold             = "70"
        threshold_duration    = "300"
        threshold_occurrences = "ALL"
  }]
}

# Pods Sample Alert
#Pods unable to be scheduled
module "cluster-pod-unschedule" {
  source          = "./nr_alert_condiction"
  nr_policy       = module.channel.nr_alert_policy_id
  condiction_type = "static"
  name		        =	"[${var.cluster_name}]-pod-schedule"
  description	    =	"Pods unable to scheduled"
  value_function  = "single_value"
  violation_time_limit_seconds = 3600
  nqrl_query = "SELECT latest(isScheduled)  FROM K8sPodSample WHERE = '${var.cluster_name}' FACET clusterName, podName "
  critical = [{ 
        operator              = "above"
        threshold             = "0"
        threshold_duration    = "300"
        threshold_occurrences = "ALL"
  }]
}

# Pods missing deployment
module "cluster-pod-missing" {
  source          = "./nr_alert_condiction"
  nr_policy       = module.channel.nr_alert_policy_id
  condiction_type = "static"
  name            =	"[${var.cluster_name}-${var.environment}]-pod-missing"
  description     = "Pods ready not equal desired "
  value_function  = "single_value"
  violation_time_limit_seconds  = 3600
  nqrl_query = "SELECT latest(podsDesired)-latest(podsReady) from K8sReplicasetSample WHERE clusterName = '${var.cluster_name}-${var.environment}' and podsReady < podsDesired "
  critical = [{ 
        operator              = "above"
        threshold             = "10"
        threshold_duration    = "300"
        threshold_occurrences = "ALL"
  }]
}


# POD Restart

module "pod-nginx-sample-restart" {
  source          = "./nr_alert_condiction"
  nr_policy       = module.channel.nr_alert_policy_id
  condiction_type = "static"
  name		        =	"pod-restart-nginx-sample"
  description	    =	"Restart Pods Sample"
  value_function  = "single_value"
  violation_time_limit_seconds =	3600
  nqrl_query = "SELECT max(restartCount) - min(restartCount) AS 'Restarts' FROM K8sContainerSample WHERE clusterName = '${var.cluster_name}-${var.environment}' AND containerName LIKE '%nginx-sample-pod%' FACET clusterName, podName"
  critical = [{ 
        operator              = "above"
        threshold             = "10"
        threshold_duration    = "180"
        threshold_occurrences = "ALL"
  }]
  warning = [{ 
        operator              = "above"
        threshold             = "5"
        threshold_duration    = "120"
        threshold_occurrences = "ALL"
  }]
}

# POD CPU Usage
module "pod-nginx-sample-cpu" {
  source          = "./nr_alert_condiction"
  nr_policy       = module.channel.nr_alert_policy_id
  condiction_type = "static"
  name            =	"pod-cpuUsage-nginx-sample"
  description     =	"CPU Usage nginx sample"
  value_function  = "single_value"
  violation_time_limit_seconds =	3600
  nqrl_query = "SELECT latest(cpuUsedCores / cpuLimitCores) * 100 as 'CPU%' FROM K8sContainerSample WHERE clusterName = '${var.cluster_name}-${var.environment}' and containerName LIKE '%nginx-sample-pod%' FACET clusterName, podName"
  critical = [{ 
        operator              = "above"
        threshold             = "90"
        threshold_duration    = "300"
        threshold_occurrences = "ALL"
  }]
  
}

# POD MEM Usage
module "pod-nginx-sample-mem" {
  source          = "./nr_alert_condiction"
  nr_policy       = module.channel.nr_alert_policy_id
  condiction_type = "static"
  name            = "pod-nginx-sample-mem"
  description     = "Memory usage nginx-sample pod"
  value_function  = "single_value"
  violation_time_limit_seconds =  3600
  nqrl_query      = "SELECT average(memoryUsedBytes / memoryLimitBytes) * 100 AS 'Memory%' FROM K8sContainerSample WHERE clusterName = '${var.cluster_name}-${var.environment}' and containerName LIKE '%nginx-sample-pod%' FACET clusterName, podName"
  critical = [{ 
        operator              = "above"
        threshold             = "90"
        threshold_duration    = "180"
        threshold_occurrences = "ALL"
  }]
  warning = [{ 
        operator              = "above"
        threshold             = "70"
        threshold_duration    = "120"
        threshold_occurrences = "ALL"
  }]
}