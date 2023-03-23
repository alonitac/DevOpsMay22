variable "env" {
  description = "Environment"
  type        = string
}


variable "region" {
  description = "AWS region"
  type        = string
}

variable "sendMail" {
  description = "Send notification to on-call engineer in case of triggered alarm"
  type        = bool
}

variable "alarm1InstanceId" {
  description = "EC2 instance ID for Alarm 1"
  type        = string
}

variable "alarm2InstanceId" {
  description = "EC2 instance ID for Alarm 2"
  type        = string
}

variable "alarm3InstanceId" {
  description = "EC2 instance ID for Alarm 3"
  type        = string
  default = null
}


variable "includeAlarm3inRegion" {
  description = "Whether to create alarm 3 in the environment/region"
  type        = bool
  default     = false
}