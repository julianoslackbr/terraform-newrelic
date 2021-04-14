## Usage

Creating a channel with two types of delivery (email and slack):
```hlc

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
```

Create Newrelic Condictions:

Alert using nrql (newrelic query language)

```hlc

module "zzzzzzzzz" {
  source          = "./nr_alert_condiction"

  nr_policy       = module.channel.nr_alert_policy_id
  condiction_type = "static"
  name		      =	"Alert Name"
  description	  =	"Mem Free Alert"
  value_function  = "single_value"
  violation_time_limit_seconds = 3600
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


```
