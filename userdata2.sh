#!/bin/bash
# Update and install Apache
apt update
apt install -y apache2 awscli

# Wait briefly to ensure metadata is available
sleep 3

# Get the instance ID using the instance metadata
INSTANCE_ID=""
retry_count=0
while [ -z "$INSTANCE_ID" ] && [ $retry_count -lt 5 ]; do
  INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
  sleep 1
  retry_count=$((retry_count + 1))
done

# Generate index.html with the instance ID
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
  <title>My Portfolio</title>
  <style>
    @keyframes colorChange {
      0% { color: red; }
      50% { color: green; }
      100% { color: blue; }
    }
    h1 {
      animation: colorChange 2s infinite;
    }
  </style>
</head>
<body>
  <h1>Terraform Project Server 1</h1>
  <h2>Instance ID: <span style="color:green">$INSTANCE_ID</span></h2>
  <p>Welcome to my second Channel</p>
</body>
</html>
EOF

# Start and enable Apache
systemctl start apache2
systemctl enable apache2
