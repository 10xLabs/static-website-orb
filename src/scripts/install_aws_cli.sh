sudo apt-get update -y
sudo apt-get install -y curl unzip
curl -sSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q -o awscliv2.zip
sudo ./aws/install
rm awscliv2.zip