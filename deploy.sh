#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${DEPLOY_TARGET:-}"
TARGET_PATH="${DEPLOY_TARGET_PATH:-}"
log_info() { echo -e "\033[0;34m[INFO]\033[0m $1"; }
log_success() { echo -e "\033[0;32m[SUCCESS]\033[0m $1"; }
log_warning() { echo -e "\033[1;33m[WARNING]\033[0m $1"; }
[ -z "$TARGET" ] && { echo "Usage: DEPLOY_TARGET=infinity ./deploy.sh"; exit 1; }
case "$TARGET" in
    infinity)
        log_info "Deploying vibes to Infinity..."
        [ -d "${SCRIPT_DIR}/vibes-fe/styles" ] && { mkdir -p "${TARGET_PATH}/src/styles/vibes"; cp -r "${SCRIPT_DIR}/vibes-fe/styles/"* "${TARGET_PATH}/src/styles/vibes/" 2>/dev/null || true; }
        [ -d "${SCRIPT_DIR}/vibes-fe/components" ] && { mkdir -p "${TARGET_PATH}/src/components/vibes"; cp -r "${SCRIPT_DIR}/vibes-fe/components/"* "${TARGET_PATH}/src/components/vibes/" 2>/dev/null || true; }
        log_success "Vibes deployed to Infinity"
        ;;
    matrix)
        log_warning "Vibes is a frontend-only module, skipping Matrix deployment"
        ;;
esac
