#!/usr/bin/env bash
# Builds a framework-dependent, single-file macOS binary
# Usage: ./build-macos.sh [arm64|x64|both]   (default: arm64)
set -euo pipefail

CONFIG="Release"
ARCH="${1:-arm64}"
PROJECT="TextureSetConverter/TextureSetConverter.csproj"

build() {
  local rid="osx-$1"
  local out="dist/$rid"
  echo "==> Building $rid"
  DOTNET_ROLL_FORWARD=Major dotnet publish "$PROJECT" \
    -c "$CONFIG" \
    -r "$rid" \
    --self-contained false \
    -p:PublishSingleFile=true \
    -o "$out"
  echo "==> Built: $out/TextureSetConverter"
}

case "$ARCH" in
  arm64) build arm64 ;;
  x64)   build x64 ;;
  both)  build arm64; build x64 ;;
  *) echo "Unknown arch '$ARCH' (expected arm64, x64, or both)" >&2; exit 1 ;;
esac
