#!/bin/bash
# ==============================================================================
# Vibes Module Deployment Script
# ==============================================================================
# Deploys Vibes CSS design system to an Infinity frontend instance.
#
# USAGE:
#   Via Spark:     spark add vibes (uses post_install hook)
#   Standalone:    DEPLOY_TARGET=infinity DEPLOY_TARGET_PATH=/path/to/infinity ./deploy.sh
#
# DEPLOYMENT:
#   - Copies CSS files to src/vibes/
#   - Adds import to main.ts (if not already present)
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${DEPLOY_TARGET:-}"
TARGET_PATH="${DEPLOY_TARGET_PATH:-}"

# Colors
log_info() { echo -e "\033[0;34m[INFO]\033[0m $1"; }
log_success() { echo -e "\033[0;32m[SUCCESS]\033[0m $1"; }
log_warning() { echo -e "\033[1;33m[WARNING]\033[0m $1"; }

# Validate arguments
[ -z "$TARGET" ] && { echo "Usage: DEPLOY_TARGET=infinity DEPLOY_TARGET_PATH=/path/to/infinity ./deploy.sh"; exit 1; }

# Add CSS import to main.js or main.ts
add_css_import() {
    local main_file=""
    local import_line="import '@/vibes/index.css'"

    # Find main.js or main.ts
    if [ -f "$1/src/main.js" ]; then
        main_file="$1/src/main.js"
    elif [ -f "$1/src/main.ts" ]; then
        main_file="$1/src/main.ts"
    else
        log_warning "main.js/main.ts not found in $1/src/ - skipping import"
        return
    fi

    # Check if import already exists
    if grep -q "@/vibes/index.css" "$main_file"; then
        log_info "CSS import already exists in $(basename "$main_file")"
        return
    fi

    # Add import after the last existing import statement
    # This preserves the import ordering
    if grep -q "^import " "$main_file"; then
        # Find line number of last import
        local last_import_line=$(grep -n "^import " "$main_file" | tail -1 | cut -d: -f1)
        # Insert after last import
        sed -i.bak "${last_import_line}a\\
${import_line}
" "$main_file"
        rm -f "$main_file.bak"
        log_success "Added CSS import to $(basename "$main_file") (after line $last_import_line)"
    else
        # No imports found, add at top
        sed -i.bak "1i\\
${import_line}
" "$main_file"
        rm -f "$main_file.bak"
        log_success "Added CSS import to $(basename "$main_file") (at top)"
    fi
}

case "$TARGET" in
    infinity)
        log_info "Deploying Vibes to Infinity..."

        # Deploy CSS files to src/vibes/
        mkdir -p "${TARGET_PATH}/src/vibes"

        # Copy main CSS files
        [ -f "${SCRIPT_DIR}/vibes-fe/vibes.css" ] && cp "${SCRIPT_DIR}/vibes-fe/vibes.css" "${TARGET_PATH}/src/vibes/"
        [ -f "${SCRIPT_DIR}/vibes-fe/index.css" ] && cp "${SCRIPT_DIR}/vibes-fe/index.css" "${TARGET_PATH}/src/vibes/"

        # Copy themes directory
        [ -d "${SCRIPT_DIR}/vibes-fe/themes" ] && cp -r "${SCRIPT_DIR}/vibes-fe/themes" "${TARGET_PATH}/src/vibes/"

        # Copy utilities directory
        [ -d "${SCRIPT_DIR}/vibes-fe/utilities" ] && cp -r "${SCRIPT_DIR}/vibes-fe/utilities" "${TARGET_PATH}/src/vibes/"

        log_success "CSS files deployed to src/vibes/"

        # Add import to main.ts
        add_css_import "$TARGET_PATH"

        log_success "Vibes deployment complete!"
        echo ""
        echo "Next: Rebuild Infinity to include CSS"
        echo "  spark build && spark restart infinity"
        ;;
    matrix)
        log_warning "Vibes is a frontend-only module, skipping Matrix deployment"
        ;;
    *)
        log_warning "Unknown target: $TARGET"
        ;;
esac
