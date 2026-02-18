#!/bin/bash
# ==========================================
# ROBUST NOTES SEARCH SYSTEM
# ==========================================

# Set your notes directory (adjust if different)
export NOTES_DIR="$HOME/Notes"

# 1. Basic search - find any term in notes
ns() {
    if [ -z "$1" ]; then
        echo "Usage: ns <search-term> [directory]"
        echo "Example: ns kubernetes"
        return 1
    fi

    local dir="${2:-$NOTES_DIR}"
    rg --color=always \
        --heading \
        --line-number \
        --smart-case \
        --hidden \
        --follow \
        "$1" "$dir"
}

# 2. Interactive fuzzy search with live preview
nf() {
    local dir="${1:-$NOTES_DIR}"

    if ! command -v fzf &>/dev/null; then
        echo "fzf not found. Install it first."
        return 1
    fi

    # Find and preview notes with fzf
    local file
    file=$(rg --files --hidden --follow "$dir" |
        fzf --preview "bat --color=always --style=numbers {} 2>/dev/null || cat {}" \
            --preview-window=right:60% \
            --height=90% \
            --border \
            --prompt="Select note: ")

    [ -n "$file" ] && ${EDITOR:-nvim} "$file"
}

# 3. Search for multiple terms (AND logic)
nsa() {
    if [ "$#" -lt 2 ]; then
        echo "Usage: nsa <term1> <term2> [term3...] [directory]"
        echo "Find notes containing ALL terms"
        echo "Example: nsa docker kubernetes deployment"
        return 1
    fi

    local dir="$NOTES_DIR"
    local terms=()

    # Parse arguments
    for arg in "$@"; do
        if [ -d "$arg" ]; then
            dir="$arg"
        else
            terms+=("$arg")
        fi
    done

    # Build ripgrep pattern for AND logic
    local pattern=$(printf "(?=.*%s)" "${terms[@]}")

    rg --color=always \
        --heading \
        --line-number \
        --smart-case \
        --hidden \
        --follow \
        --pcre2 \
        "$pattern" "$dir"
}

# 4. Search with context (show surrounding lines)
nsc() {
    if [ -z "$1" ]; then
        echo "Usage: nsc <search-term> [context-lines] [directory]"
        echo "Show surrounding context (default: 3 lines)"
        return 1
    fi

    local term="$1"
    local context="${2:-3}"
    local dir="${3:-$NOTES_DIR}"

    rg --color=always \
        --heading \
        --line-number \
        --smart-case \
        --hidden \
        --follow \
        --context "$context" \
        "$term" "$dir"
}

# 5. Search by file type
nst() {
    if [ "$#" -lt 2 ]; then
        echo "Usage: nst <file-type> <search-term> [directory]"
        echo "Example: nst md kubernetes"
        return 1
    fi

    local filetype="$1"
    local term="$2"
    local dir="${3:-$NOTES_DIR}"

    rg --color=always \
        --heading \
        --line-number \
        --smart-case \
        --type "$filetype" \
        --hidden \
        --follow \
        "$term" "$dir"
}

# 6. Search and replace (dry-run first)
nsr-replace() {
    if [ "$#" -lt 2 ]; then
        echo "Usage: nsr-replace <search> <replace> [directory]"
        echo "Shows what would be replaced (dry-run)"
        echo "Use nsr-replace-exec to actually replace"
        return 1
    fi

    local search="$1"
    local replace="$2"
    local dir="${3:-$NOTES_DIR}"

    echo "Files that would be modified:"
    rg --files-with-matches --hidden --follow "$search" "$dir"
    echo ""
    echo "Preview of changes:"
    rg --color=always "$search" "$dir"
}

# 7. Statistics about your notes
nstats() {
    local dir="${1:-$NOTES_DIR}"

    echo "📊 Notes Statistics"
    echo "===================="
    echo "Total files: $(find "$dir" -type f | wc -l)"
    echo "Total lines: $(find "$dir" -type f -exec cat {} \; | wc -l)"
    echo "Total words: $(find "$dir" -type f -exec cat {} \; | wc -w)"
    echo ""
    echo "File types:"
    find "$dir" -type f | sed 's/.*\.//' | sort | uniq -c | sort -rn | head -10
    echo ""
    echo "Largest files:"
    find "$dir" -type f -exec du -h {} \; | sort -rh | head -5
}

# 8. Help function
nshelp() {
    cat <<'EOF'
🔍 Notes Search System Commands
================================

Basic Search:
  ns <term>              - Search for term in notes
  nsc <term> [context]   - Search with context lines (default: 3)
  nsa <term1> <term2>    - Search for multiple terms (AND)
  nst <type> <term>      - Search by file type (md, txt, etc.)

Interactive/Fuzzy Search:
  nf                     - Browse notes with fzf

Utilities:
  nstats                 - Show notes statistics
  nshelp                 - Show this help

Examples:
  ns kubernetes                    # Simple search
  nfs "docker compose"             # Interactive search
  nsa docker kubernetes production # Find notes with all 3 terms
  nsc error 5                      # Search "error" with 5 lines context

Directory: $NOTES_DIR
EOF
}

# Optional: Completion for note search
# Add tab completion for your notes
_notes_completion() {
    local notes_files=($(rg --files "$NOTES_DIR" 2>/dev/null))
    _describe 'notes' notes_files
}

compdef _notes_completion nf
