## Azure project configuration
instance_name = "vpn_service"
key_data      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCb7T6hz3sH+wynfqhiTo8D3FzW0UR+aBpQna8u72b/vX4T0PV6Aii0/r4YlNGCf+l8wECs1kn2Z+OxsBHL2t5RS8H5l6YXNPDg5ciurwp4JlKbstxA90DMF8JKG7pbiNYpoqbIOP944rWzHeUNYTREdqWy8ghjPb7AKh+cDQPRGrgRUkoAg/Oy3fOI45WkT5hHoUARLEDEcYWto3ImSgts7OaJm8FmkZWKnoxGp5SqKeiIdvOGDEvJEJzK+fmRFYaytbNDesYZaVGhcnc30xl33OzyCp4OU738mKCea0KY0Vcos/tJjG+I8yT6n3KQl4KyETGY3T8wmmYJfejBJioMOqaCRuG6X4Rn5/SMdQ7fOECkvRzMrb8BbxzJYLUHKWb+Vk8WW5AWorbXdyrvV5yYTySthhhsuaj12fLp+SFTqbP8A5+xe2ijAcrgWi8VLhrx7aU/Wq2XTNJEm4lOq3W9OEIL5ncqfcYZOlb2MQa3c7axBcDF3JWs+irmk3ymi1E="

# Azure location
location = "Germany West Central"

# Azure resource group prefix
resource_group_name_prefix = "vpn_service"

# Azure resource_prefix
resource_prefix = "vpn_service"

# Azure environment
environment = "production"  # or "development", "staging", etc.

# Azure project name
project_name = "vpn_service"  # or whatever name you want to give your project

# VM specs 
vm_size = "Standard_D8ds_v4"
disk_size_gb = 1000 # 1000GB disk

# User
admin_username = "organic"