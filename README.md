Install zsh with base config


One command install:
```shell
TMP_DIR=$(mktemp -d) && git clone --depth 1 https://github.com/overgodofchaos/zsh-profile.git "$TMP_DIR" && (cd "$TMP_DIR" && chmod +x install.sh && ./install.sh) ; rm -rf "$TMP_DIR"
```