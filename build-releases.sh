#!/bin/bash
set -e

mkdir -p release-builds
rm -f release-builds/*

echo "🚀 Building release binaries..."

targets=(
    "linux/amd64/kilat-linux-amd64"
    "linux/arm64/kilat-linux-arm64"
    "linux/arm/kilat-linux-armv7"
    "darwin/amd64/kilat-darwin-amd64"
    "darwin/arm64/kilat-darwin-arm64"
    "windows/amd64/kilat-windows-amd64.exe"
    "windows/arm64/kilat-windows-arm64.exe"
)

for target in "${targets[@]}"; do
    IFS="/" read -r goos goarch name <<< "$target"
    echo "📦 Building $name ($goos/$goarch)..."
    if [ "$goarch" = "arm" ]; then
        CGO_ENABLED=0 GOOS="$goos" GOARCH="$goarch" GOARM=7 go build -trimpath -ldflags="-s -w" -o "release-builds/$name" ./cmd/kilat
    else
        CGO_ENABLED=0 GOOS="$goos" GOARCH="$goarch" go build -trimpath -ldflags="-s -w" -o "release-builds/$name" ./cmd/kilat
    fi
    echo "  ✅ Done: release-builds/$name"
done

echo "✨ All release binaries compiled successfully!"
ls -lh release-builds/
