#!/bin/bash
set -e

FILENAME=$1

# This uses the public age key for kian-wsl to encrypt files and uses the private key managed via a kubernetes secret created via CLI to decrypt later

if [ -z "$FILENAME" ]; then
    echo "USAGE: $0 <filename>"
    exit 1
fi

# Check if file exists
if [ -f "$FILENAME" ]; then
    echo "FOUND: $FILENAME"
    read -p "ENCRYPT THIS FILE? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sops --encrypt --in-place "$FILENAME"
        echo "ENCRYPTED: $FILENAME"
    else
        echo "CANCELLED."
        exit 0
    fi
else
    echo "FILE NOT FOUND: $FILENAME"
    echo "SEARCHING FOR SIMILAR FILES..."
    
    # Extract just the filename without path
    BASENAME=$(basename "$FILENAME")
    
    # Search for files with similar names (case-insensitive)
    mapfile -t MATCHES < <(find . -type f -iname "*${BASENAME}*" 2>/dev/null | head -n 10)
    
    if [ ${#MATCHES[@]} -eq 0 ]; then
        echo "NO SIMILAR FILES FOUND."
        exit 1
    fi
    
    echo "FOUND ${#MATCHES[@]} SIMILAR FILE(S):"
    for i in "${!MATCHES[@]}"; do
        echo "  [$i] ${MATCHES[$i]}"
    done
    
    read -p "SELECT FILE NUMBER TO ENCRYPT (OR 'q' TO QUIT): " SELECTION
    
    if [[ $SELECTION == "q" ]]; then
        echo "CANCELLED."
        exit 0
    fi
    
    if [[ $SELECTION =~ ^[0-9]+$ ]] && [ $SELECTION -ge 0 ] && [ $SELECTION -lt ${#MATCHES[@]} ]; then
        SELECTED_FILE="${MATCHES[$SELECTION]}"
        echo "SELECTED: $SELECTED_FILE"
        read -p "ENCRYPT THIS FILE? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            sops --encrypt --in-place "$SELECTED_FILE"
            echo "ENCRYPTED: $SELECTED_FILE"
        else
            echo "CANCELLED."
            exit 0
        fi
    else
        echo "INVALID SELECTION."
        exit 1
    fi
fi