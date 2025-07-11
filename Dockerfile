FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 安装基础工具和依赖
RUN apt-get update && \
    apt-get install -y curl git build-essential ca-certificates sudo && \
    rm -rf /var/lib/apt/lists/*

# 安装 mise
RUN curl https://mise.run | bash

# mise 全局配置目录
ENV MISE_GLOBAL_CONFIG_DIR=/etc/mise
RUN mkdir -p $MISE_GLOBAL_CONFIG_DIR

# 配置 mise 全局环境变量和 profile
RUN echo 'export MISE_GLOBAL_CONFIG_DIR=/etc/mise' > /etc/profile.d/mise.sh && \
    echo 'export PATH="/root/.local/bin:$PATH"' >> /etc/profile.d/mise.sh && \
    echo 'export PATH="$HOME/.local/share/mise/shims:$PATH"' >> /etc/profile.d/mise.sh && \
    echo 'eval "$(mise activate bash)"' >> /etc/profile.d/mise.sh

# 复制全局 mise 配置文件（可根据需要修改）
COPY mise.toml /etc/mise/mise.toml

# 根据 ENV_LANGS 环境变量自动初始化语言环境
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]