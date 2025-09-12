# Optional CLI Tools

## Install zellij via terminal

### 1. Download
```bash
curl -L -o zellij.tar.gz "https://github.com/zellij-org/zellij/releases/latest/download/zellij-no-web-x86_64-unknown-linux-musl.tar.gz"
```

### 2. Verify it arrived
```bash
ls -lh zellij.tar.gz
```

### 3. Extract everything
```bash
tar -xzf zellij.tar.gz
```

### 4. See what came out
```bash
ls -l
```

### 5. Make it executable and move it to bin to use everywhere 
make it executable

```bash
chmod +x zellij
```

put it on your PATH

```bash
sudo mv zellij /usr/local/bin/
```