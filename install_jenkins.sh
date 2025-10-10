#!/usr/bin/env bash
set -euo pipefail

# Ensure we can sudo without prompts mid-script
sudo -v

# 1) Prereqs + Java (Jenkins supports Java 17/21; using 17)
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg fontconfig openjdk-17-jre

# 2) Add Jenkins repo + key
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key \
  | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
  | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# 3) Install Jenkins
sudo apt-get update
sudo apt-get install -y jenkins

# 4) Open firewall (if UFW is active)
if command -v ufw >/dev/null 2>&1 && sudo ufw status | grep -qi "Status: active"; then
  sudo ufw allow 8080/tcp
fi

# 5) Enable + start Jenkins
sudo systemctl enable --now jenkins

# 6) Show status + initial admin password
sudo systemctl --no-pager status jenkins || true
echo
echo "Initial admin password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
echo
echo "Open: http://<your-server-ip>:8080"
