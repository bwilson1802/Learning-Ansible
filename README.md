Log into AWS and open vpc and crate an enviornment
select Ubuntu

run
1. sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
2. wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
3. gpg --no-default-keyring \
    --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    --fingerprint
4. echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list
5. sudo apt update
6. sudo apt-get install terraform
7. sudo apt install jq
8. terraform show -json | jq
9. go to terraform workspace and generate code
10. copy code 
11. terraform login and paste code
12. add backends, providers, variables, tfvars
13. add a vpc to networking
14. terraform init, plan, apply to check sys
15. ssh-keygen -t rsa
16. /home/ubuntu/.ssh/btckey
17. no phrase
18. add in the rest of compute and networking
 