#!/bin/bash
# LibraryManagement — EC2 セットアップスクリプト
# terraform apply 後に EC2 に SSH してから実行してください。
#
# 実行方法:
#   scp -i ~/.ssh/id_rsa setup.sh ec2-user@<EC2_IP>:~/
#   ssh -i ~/.ssh/id_rsa ec2-user@<EC2_IP>
#   chmod +x ~/setup.sh && ~/setup.sh

set -euo pipefail

# ══════════════════════════════════════════════════════════════════════
# ★ 実行前にここだけ書き換えてください（terraform output で確認可能）
# ══════════════════════════════════════════════════════════════════════
DB_HOST="YOUR_RDS_ENDPOINT"       # terraform output rds_endpoint
DB_PASSWORD="YOUR_DB_PASSWORD"    # terraform.tfvars に書いた db_password
REPO_URL="https://github.com/saku-day1/LibraryManagement.git"
APP_DIR="/var/www/library-management"
# ══════════════════════════════════════════════════════════════════════

echo "==> [1/8] システムパッケージを更新"
sudo dnf update -y
sudo dnf install -y git nginx gcc gcc-c++ make \
  openssl-devel readline-devel zlib-devel libffi-devel \
  libyaml-devel mysql-devel

echo "==> [2/8] Node.js 24 をインストール"
curl -fsSL https://rpm.nodesource.com/setup_24.x | sudo bash -
sudo dnf install -y nodejs

echo "==> [3/8] rbenv + Ruby 3.3 をインストール"
if [ ! -d "$HOME/.rbenv" ]; then
  git clone https://github.com/rbenv/rbenv.git ~/.rbenv
  git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
  echo 'eval "$(rbenv init -)"' >> ~/.bashrc
fi
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

rbenv install -s 3.3.11
rbenv global 3.3.11
gem install bundler --no-document

echo "==> [4/8] リポジトリをクローン"
sudo mkdir -p "$APP_DIR"
sudo chown ec2-user:ec2-user "$APP_DIR"
git clone "$REPO_URL" "$APP_DIR"

echo "==> [5/8] Rails セットアップ"
SECRET_KEY_BASE=$(openssl rand -hex 64)

cat > "$APP_DIR/backend/.env.production" << EOF
RAILS_ENV=production
DB_HOST=${DB_HOST}
DB_USERNAME=admin
DB_PASSWORD=${DB_PASSWORD}
DB_NAME=library_management_production
SECRET_KEY_BASE=${SECRET_KEY_BASE}
RAILS_LOG_TO_STDOUT=true
EOF

cd "$APP_DIR/backend"
bundle config set --local without 'development test'
bundle install
RAILS_ENV=production bundle exec rails db:migrate

echo "==> [6/8] Vue をビルド"
cd "$APP_DIR/frontend"
npm ci
npm run build

echo "==> [7/8] Nginx を設定"
sudo tee /etc/nginx/conf.d/library-management.conf > /dev/null << 'NGINX'
server {
    listen 80;
    server_name _;

    root /var/www/library-management/frontend/dist;
    index index.html;

    location /api {
        proxy_pass         http://127.0.0.1:3000;
        proxy_set_header   Host              $host;
        proxy_set_header   X-Real-IP         $remote_addr;
        proxy_set_header   X-Forwarded-For   $proxy_add_x_forwarded_for;
    }

    location / {
        try_files $uri $uri/ /index.html;
    }
}
NGINX

sudo nginx -t
sudo systemctl enable --now nginx

echo "==> [8/8] Puma を systemd サービスとして登録"
BUNDLE_PATH=$(rbenv which bundle)

sudo tee /etc/systemd/system/puma.service > /dev/null << EOF
[Unit]
Description=Puma HTTP Server (LibraryManagement)
After=network.target

[Service]
Type=simple
User=ec2-user
WorkingDirectory=${APP_DIR}/backend
EnvironmentFile=${APP_DIR}/backend/.env.production
ExecStart=${BUNDLE_PATH} exec rails server -e production -b 127.0.0.1 -p 3000
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now puma

echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║           セットアップ完了！                     ║"
echo "╚══════════════════════════════════════════════════╝"
PUBLIC_IP=$(curl -s ifconfig.me)
echo ""
echo "  アプリ URL : http://${PUBLIC_IP}"
echo "  ログ確認   : sudo journalctl -u puma -f"
echo "               sudo journalctl -u nginx -f"
echo ""
