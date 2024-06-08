# CS-312-Final

# Setting up a minecraft server using terraform and docker

## Backround:
We will be creating a working minecraft world using nothing but an aws account, a terraform script, and 
docker (although the terraform script will handle docker for us). The actual man work is relatively easy,
as all that is required of us is to write a terraform script that connects to our amazon account, 
sets up a valid ec2 instance on it, and then runs commands to install and configure a docker container of 
minecraft. from our end, all we will need to run is `terraform init` and `terraform apply` before we can play!

## REQUIREMENTS:
- An amazon aws account that has access to creating EC2 instances
- Your aws credentials in the .ssh folder (or set environment variables)
- terraform installed on your local client [download here](https://developer.hashicorp.com/terraform/install?ajs_aid=cf567d59-178c-4de8-a80c-8abba64f7e28&product_intent=terraform)
- That's all!

## Making sure you can access everything 
- Make sure that you have the required credentials in your .ssh folder for your amazon account,
or that you have set the environment variables for `aws_access_key_id`, `aws_secret_access_key_id`, and `aws_session_token`
- Make sure that you have terraform installed and working by running terraform --version


## Commands to run once terraform script is written/downloaded
- Run `terraform fmt` to make sure that your terraform scripts is formatted correctly. 
- Run `terraform init` to set up the terraform scripts to work correctly.
- Run `terraform apply` to run the script. 

## Connecting to the server
- You should be able to connect to the server by simply putting the public IP address
outputted when running the script into your minecraft browser!



