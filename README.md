# Web nodejs application
This repository deploys a Nodejs sample application using the 
[API with Express & Handlebar Templates example](https://github.com/nodejs/examples/tree/main/servers/express/api-with-express-and-handlebars)
into AWS using a public application load balancer, an auto scaling group and EC2 instances in 2 availability zones.
This infrastructure is provisioned using configuration as code with Terraform.

## Diagram
This diagram shows a common diagram for the configuration implemented:
![Alt text](diagram.png?raw=true "Diagram")

## Infrastructure components
Next, I will describe different components included in this solution:
### Load balancer
This application has been configured using a public facing load balancer. It allows all HTTP traffic coming to port 80
for instances in all subnets for the current region. Listener is configured to forward traffic to a target group on port
3000 where the Nodejs are serving the API. A security group is configured to allow only traffic coming from any IP v4.

For simplicity, I have used default VPC and default subnets to deploy instances to. A production environments normally
uses a custom VPC with public and private subnets to deploy instances.
A target group has been associated with the application load balancer to send traffic to deployed instances.
### Instances configuration
To scale the application, I have created an auto scaling group in a specified set of availability zones using a
Terraform variable. Other input variables include `desired`, `max`, `min` and `scaling_adjustment` to define the desired
running instances, maximum number of running instances, minimum number or running instances and scale factor when load
increases respectively. 

`cooldown period` has been set to 5 minutes to allow enough time for the auto scaling group to launch new instances.
When load increases, I have configured a CloudWatch metric alarm to launch new `scaling_adjustment` units when the
`NetworkOut` metric reaches 50kb of size. This a basic example to trigger the scaling policy for basic usage. Production
workload can use more complex scaling policies based on CPU, memory or requests/time.

Instance configuration has been set using AWS Launch templates specifying the image ID (Amazon AMI), instance type,
network configuration (public facing EC2 instances) and an [User data script](tf/user_data.sh) to bootstrap the Nodejs application.
A security group for the instances only allows traffic to port 3000 only coming from the load balancer.

## Load testing the application
To load testing the application I have created a sample scenario to simulate the load of 10 concurrent users during 30
seconds to call an endpoint (/dependencies in this case, but more complex scenarios can be configured).

I have used [Grafana k6 tool](https://github.com/grafana/k6) for this purpose although other tools can be used for this
purpose or even programing languages.

## Terraform environments
To configure different set of environments and example directories, I have include a [environments folder](tf/environments).
Normally you will create different folders for staging and production set of variables.

## Deploy infrastructure and load testing

Deploy steps to provision infrastructure:

```shell script
cd tf
terraform apply -var-file=environments/dev/terraform.tfvars
```

To run load testing script, install `k6` locally and then run:

```shell script
k6 run load_test.sh
```

Normally these scripts will be run by CI/CD pipelines. For simplicity I have not included them in this repository as I
consider it is out of the scope for this example.


