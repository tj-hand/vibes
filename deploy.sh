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

        # Deploy to infinity/src/vibes/ (existing placeholder folder)
        mkdir -p "${TARGET_PATH}/src/vibes"

        # Copy main CSS files
        [ -f "${SCRIPT_DIR}/vibes-fe/vibes.css" ] && cp "${SCRIPT_DIR}/vibes-fe/vibes.css" "${TARGET_PATH}/src/vibes/"
        [ -f "${SCRIPT_DIR}/vibes-fe/index.css" ] && cp "${SCRIPT_DIR}/vibes-fe/index.css" "${TARGET_PATH}/src/vibes/"

        # Copy themes directory
        [ -d "${SCRIPT_DIR}/vibes-fe/themes" ] && cp -r "${SCRIPT_DIR}/vibes-fe/themes" "${TARGET_PATH}/src/vibes/"

        # Copy utilities directory
        [ -d "${SCRIPT_DIR}/vibes-fe/utilities" ] && cp -r "${SCRIPT_DIR}/vibes-fe/utilities" "${TARGET_PATH}/src/vibes/"

        log_success "Vibes deployed to Infinity (src/vibes/)"
        ;;
    matrix)
        log_warning "Vibes is a frontend-only module, skipping Matrix deployment"
        ;;
esac
