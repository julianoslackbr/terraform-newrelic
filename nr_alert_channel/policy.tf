locals {

 channel_email = [ for i in var.channel_config: i if i.type == "email" ]
 channel_slack = [ for i in var.channel_config: i if i.type == "slack"]
}



resource "newrelic_alert_channel" "email" {
  name = var.name
  type = "email"
  count = length(local.channel_email)

  dynamic "config" {
    for_each = local.channel_email
      content {
        recipients              = config.value["recipients"]
        include_json_attachment = config.value["include_json_attachment"] 
        
      }
  }
}
    

resource "newrelic_alert_channel" "slack" {
  name = var.name
  type = "slack"
  count = length(local.channel_slack)

  dynamic "config" {
    for_each = local.channel_slack
      content {
        url     = config.value["url"]
        channel = config.value["channel"] 
        
      }
  }
    
}

resource "newrelic_alert_policy" "alert" {
  name = var.name

  incident_preference = "PER_CONDITION"

  channel_ids = tolist(concat(newrelic_alert_channel.email.*.id, newrelic_alert_channel.slack.*.id))


  depends_on = [
    newrelic_alert_channel.slack,
    newrelic_alert_channel.email
  ]
}