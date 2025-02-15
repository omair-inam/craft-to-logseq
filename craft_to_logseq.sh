#!/bin/bash

# Script: logseq-md-processor.sh
# Description: Processes markdown files and their assets for Logseq
# Usage: ./logseq-md-processor.sh --logseq-path /path/to/logseq --output-dir /path/to/output [--verbose]

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOG_FILE="$SCRIPT_DIR/logseq-md-processor-$(date +%Y%m%d_%H%M%S).log"

# Initialize variables
LOGSEQ_PATH=""
OUTPUT_DIR=""
VERBOSE=false

# Logging function
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
    if [ "$VERBOSE" = true ]; then
        echo "$1"
    fi
}

# Display help message
show_help() {
    cat << EOF
Usage: $(basename $0) --logseq-path PATH --output-dir DIR [--verbose]

Process markdown files and their assets for Logseq integration.

Required arguments:
    -l, --logseq-path PATH    Path to Logseq directory
    -o, --output-dir DIR      Temporary output directory for processing

Optional arguments:
    -v, --verbose             Enable verbose output
    -h, --help               Show this help message

Example:
    $(basename $0) -l ~/Documents/logseq -o ./temp_output -v

Steps performed:
1. Validates Logseq directory structure
2. Processes markdown files using longdown
3. Copies asset directories to Logseq
4. Fixes image paths in markdown files
5. Moves processed files to Logseq pages directory
EOF
    exit 1
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -l|--logseq-path)
            LOGSEQ_PATH="$2"
            shift 2
            ;;
        -o|--output-dir)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -h|--help)
            show_help
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            ;;
    esac
done

# Validate required arguments
if [ -z "$LOGSEQ_PATH" ] || [ -z "$OUTPUT_DIR" ]; then
    echo "Error: Missing required arguments"
    show_help
fi

# Validate Logseq directory
if [ ! -d "$LOGSEQ_PATH" ]; then
    log "Error: Logseq directory does not exist: $LOGSEQ_PATH"
    exit 1
fi

# Validate Logseq directory structure
if [ ! -d "$LOGSEQ_PATH/pages" ] || [ ! -d "$LOGSEQ_PATH/assets" ]; then
    log "Error: Invalid Logseq directory structure. Missing pages or assets directory"
    exit 1
fi

# Clean/create output directory
if [ -d "$OUTPUT_DIR" ]; then
    read -p "Output directory exists. Clear it? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        log "Cleaning output directory: $OUTPUT_DIR"
        rm -rf "$OUTPUT_DIR"/*
    else
        log "Operation cancelled by user"
        exit 1
    fi
else
    log "Creating output directory: $OUTPUT_DIR"
    mkdir -p "$OUTPUT_DIR"
fi

# Process markdown files
log "Processing markdown files with longdown"
longdown -d "$OUTPUT_DIR" *.md

# Copy assets
log "Copying asset directories to Logseq"
(cp -r ./*.assets "$LOGSEQ_PATH/assets/" 2>/dev/null || true) && \
log "Assets copied successfully (or no assets found)"

# Update markdown files
log "Updating image paths in markdown files"
find "$OUTPUT_DIR" -name "*.md" -exec sed -i '' \
    -e 's/\(!\[.*\.png\]\)(/\1(..\/assets\//g' \
    -e 's/%20/ /g' {} + && \
log "Markdown files updated successfully"

# Move processed files
log "Moving processed files to Logseq pages directory"
mv "$OUTPUT_DIR"/*.md "$LOGSEQ_PATH/pages/" && \
log "Files moved successfully"

# Cleanup
log "Cleaning up temporary directory"
rm -rf "$OUTPUT_DIR"

log "Processing completed successfully"