#!/bin/bash
set -e

export PATH="/root/.local/bin:$PATH"

# 解析 ENV_LANGS 环境变量，格式如 'node@lts python@3.11 go@1.21'
if [ -n "$ENV_LANGS" ]; then
  echo "[tools]" > /etc/mise/mise.toml
  for lang in $ENV_LANGS; do
    name=$(echo $lang | cut -d'@' -f1)
    version=$(echo $lang | cut -d'@' -f2)
    echo "$name = \"$version\"" >> /etc/mise/mise.toml
  done
  # 全局安装
  source /etc/profile.d/mise.sh
  mise install
fi

exec "$@"