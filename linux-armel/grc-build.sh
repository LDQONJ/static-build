export PATH="/root/arm-linux-musleabi-cross/bin:$PATH"
command -v cargo >/dev/null 2>&1 || curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"

rustup target add arm-unknown-linux-musleabi

mkdir -p ~/.cargo
cat << 'EOF' >> ~/.cargo/config.toml
[target.arm-unknown-linux-musleabi]
linker = "/root/arm-linux-musleabi-cross/bin/arm-linux-musleabi-gcc"
rustflags = ["-C", "target-feature=+crt-static"]
EOF

cd ~
git clone --depth 1 https://github.com/lazywalker/rgrc.git
cd rgrc
cargo build --release --target arm-unknown-linux-musleabi

arm-linux-musleabi-strip target/arm-unknown-linux-musleabi/release/rgrc
