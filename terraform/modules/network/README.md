## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.natgw_eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.natgw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.private_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.public_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.private_internet_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public_internet_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_ssm_parameter.database_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.public_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_subnet.database_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.private_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_availability_zones.region_azones](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region | `string` | `"us-east-1"` | no |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Common tags | `map(string)` | <pre>{<br>  "created_by": "terraform-linuxtips-aws-container-architecture",<br>  "day": "day1",<br>  "sandbox": "linuxtips"<br>}</pre> | no |
| <a name="input_databases_subnet_cidr"></a> [databases\_subnet\_cidr](#input\_databases\_subnet\_cidr) | The databases subnet CIDR | `list(string)` | <pre>[<br>  "10.0.51.0/24",<br>  "10.0.52.0/24",<br>  "10.0.53.0/24"<br>]</pre> | no |
| <a name="input_private_subnet_cidr"></a> [private\_subnet\_cidr](#input\_private\_subnet\_cidr) | The private subnet CIDR | `list(string)` | <pre>[<br>  "10.0.0.0/20",<br>  "10.0.16.0/20",<br>  "10.0.32.0/20"<br>]</pre> | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The resource name sufix | `string` | `"linuxtips"` | no |
| <a name="input_public_subnet_cidr"></a> [public\_subnet\_cidr](#input\_public\_subnet\_cidr) | The public subnet CIDR | `list(string)` | <pre>[<br>  "10.0.48.0/24",<br>  "10.0.49.0/24",<br>  "10.0.50.0/24"<br>]</pre> | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | The VPC CIDR | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ssm_parameter_database_subnets"></a> [ssm\_parameter\_database\_subnets](#output\_ssm\_parameter\_database\_subnets) | AWS SSM parameter store database subnets id |
| <a name="output_ssm_parameter_private_subnets"></a> [ssm\_parameter\_private\_subnets](#output\_ssm\_parameter\_private\_subnets) | AWS SSM parameter store private subnets id |
| <a name="output_ssm_parameter_public_subnets"></a> [ssm\_parameter\_public\_subnets](#output\_ssm\_parameter\_public\_subnets) | AWS SSM parameter store public subnets id |
| <a name="output_ssm_parameter_vpc"></a> [ssm\_parameter\_vpc](#output\_ssm\_parameter\_vpc) | AWS SSM parameter store VPC id |
