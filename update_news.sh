#!/bin/bash

# Script to update tech news index.md with new HTML files
# Usage: ./update_tech_index.sh [directory]

cp ../scrape-news/html/*html all-things-tech/

# Set default directory to current working directory if not provided
TECH_DIR="${1:-$(pwd)}"

# Check if we're in the right directory structure
if [[ ! -d "$TECH_DIR/all-things-tech" ]]; then
    echo " Error: all-things-tech directory not found in $TECH_DIR"
    echo "Usage: $0 [path_to_github_pages_directory]"
    echo "Example: $0 /path/to/anish7605.github.io"
    exit 1
fi

INDEX_FILE="$TECH_DIR/all-things-tech/index.md"
TECH_NEWS_DIR="$TECH_DIR/all-things-tech"

# Check if index.md exists
if [[ ! -f "$INDEX_FILE" ]]; then
    echo " Error: $INDEX_FILE not found"
    exit 1
fi

echo " Scanning for new tech news HTML files in $TECH_NEWS_DIR..."

# Find all HTML files that match news patterns
html_files=($(find "$TECH_NEWS_DIR" -name "tech_news_*.html" -o -name "tech_news_security_*.html" -o -name "linux_news_*.html" -o -name "robotics_news_*.html" -o -name "security_news_*.html" -o -name "combined_news_*.html" | sort -r))

if [[ ${#html_files[@]} -eq 0 ]]; then
    echo "ℹ️  No tech news HTML files found"
    exit 0
fi

echo " Found ${#html_files[@]} HTML file(s)"

# Create a backup of the current index.md
backup_file="$INDEX_FILE.backup.$(date +%Y%m%d_%H%M%S)"
cp "$INDEX_FILE" "$backup_file"
echo " Created backup: $backup_file"

# Read the current index.md and extract existing entries
existing_entries=()
while IFS= read -r line; do
    if [[ "$line" =~ ^\-[[:space:]]*\[.*\]\(.*\.html\) ]]; then
        # Extract the filename from the markdown link
        filename=$(echo "$line" | sed -n 's/.*(\([^)]*\.html\)).*/\1/p' | xargs basename)
        existing_entries+=("$filename")
    fi
done < "$INDEX_FILE"

echo " Found ${#existing_entries[@]} existing entries in index"

# Process each HTML file and collect entries
new_entries_added=0
temp_entries_raw=()

for html_file in "${html_files[@]}"; do
    filename=$(basename "$html_file")
    
    # Skip if entry already exists
    if printf '%s\n' "${existing_entries[@]}" | grep -q "^$filename$"; then
        echo "⏭️  Skipping $filename (already in index)"
        continue
    fi
    
    echo "🆕 Processing new file: $filename"
    
    url_path="all-things-tech"
    file_type=""
    date_str=""
    priority=""
    
    # Determine file type and extract date - Handle all news types
    if [[ "$filename" =~ ^combined_news.*_([0-9]{8})_[0-9]{6}\.html$ ]]; then
        # Combined news file - Skip these to avoid duplication
        echo "⏭️  Skipping combined report: $filename (processing individual files instead)"
        continue
    elif [[ "$filename" =~ ^linux_news_([0-9]{8})_[0-9]{6}\.html$ ]]; then
        # Linux news file
        date_str="${BASH_REMATCH[1]}"
        file_type=" Linux"
        priority="4"  # Linux goes last
        echo " Matched linux pattern: $filename -> $date_str"
    elif [[ "$filename" =~ ^robotics_news_([0-9]{8})_[0-9]{6}\.html$ ]]; then
        # Robotics news file
        date_str="${BASH_REMATCH[1]}"
        file_type=" Robotics"
        priority="3"
        echo " Matched robotics pattern: $filename -> $date_str"
    elif [[ "$filename" =~ ^security_news_([0-9]{8})_[0-9]{6}\.html$ ]]; then
        # Security news file (new format)
        date_str="${BASH_REMATCH[1]}"
        file_type=" Security"
        priority="2"
        echo " Matched security pattern: $filename -> $date_str"
    elif [[ "$filename" =~ ^tech_news_security_([0-9]{8})_[0-9]{6}\.html$ ]]; then
        # Security news file (old format)
        date_str="${BASH_REMATCH[1]}"
        file_type=" Security"
        priority="2"
        echo " Matched tech security pattern: $filename -> $date_str"
    elif [[ "$filename" =~ ^tech_news_([0-9]{8})_[0-9]{6}\.html$ ]]; then
        # Regular tech news file
        date_str="${BASH_REMATCH[1]}"
        file_type=" Tech"
        priority="1"  # Tech goes first
        echo " Matched tech pattern: $filename -> $date_str"
    else
        echo "️  Warning: Cannot parse date from $filename, skipping"
        continue
    fi
    
    # Convert YYYYMMDD to MM/DD/YYYY format for display
    if [[ "$date_str" =~ ^([0-9]{4})([0-9]{2})([0-9]{2})$ ]]; then
        year="${BASH_REMATCH[1]}"
        month="${BASH_REMATCH[2]}"
        day="${BASH_REMATCH[3]}"
        # Format as MM/DD/YYYY for display (matching your existing format)
        display_date="$(printf "%02d/%02d/%s" $((10#$month)) $((10#$day)) $year)"
    else
        echo "️  Warning: Invalid date format in $filename, skipping"
        continue
    fi
    
    # Create the new entry with sorting information
    sort_key="${date_str}${priority}"
    entry_text="- [$file_type $display_date](https://anish7600.github.io/$url_path/$filename)"
    temp_entries_raw+=("$sort_key|$entry_text")
    
    echo " Prepared entry: $file_type $display_date (priority: $priority)"
    ((new_entries_added++))
done

# Sort entries by date (descending) then by priority (ascending)
temp_entries=()
while IFS='|' read -r sort_key entry_text; do
    temp_entries+=("$entry_text")
done < <(printf '%s\n' "${temp_entries_raw[@]}" | sort -t'|' -k1,1r)

# If no new entries, exit
if [[ $new_entries_added -eq 0 ]]; then
    echo "ℹ️  No new entries to add"
    rm "$backup_file" 2>/dev/null
    exit 0
fi

# Update the index.md file
echo " Updating $INDEX_FILE with $new_entries_added new entries..."

# Create new index content
{
    # Read everything before ## Tech News section
    while IFS= read -r line; do
        echo "$line"
        if [[ "$line" == "## Tech News" ]]; then
            # Add empty line after header
            echo ""
            # Add new entries first (most recent first)
            for entry in "${temp_entries[@]}"; do
                echo "$entry"
            done
            break
        fi
    done < "$INDEX_FILE"
    
    # Now add existing entries from the original file
    in_tech_section=false
    while IFS= read -r line; do
        if [[ "$line" == "## Tech News" ]]; then
            in_tech_section=true
            continue
        fi
        
        # Only process lines after ## Tech News header
        if [[ "$in_tech_section" == true ]]; then
            # Add existing markdown links for news files
            if [[ "$line" =~ ^\-[[:space:]]*\[.*\]\(.*\.html\) ]]; then
                echo "$line"
            fi
        fi
    done < "$INDEX_FILE"
    
} > "$INDEX_FILE.tmp"

# Replace the original file
mv "$INDEX_FILE.tmp" "$INDEX_FILE"

echo " Successfully updated $INDEX_FILE"
echo " Summary:"
echo "   • Added: $new_entries_added new entries"
echo "   • Processed HTML files: ${#html_files[@]}"
echo "   • Skipped existing entries: $((${#html_files[@]} - $new_entries_added))"
echo "   • Backup saved: $backup_file"

# Show the updated content
echo ""
echo " Updated index content (Tech News section):"
echo "============================================="
sed -n '/^## Tech News/,/^## /p' "$INDEX_FILE" | head -n -1

# Optional: Show git status if we're in a git repo
if git rev-parse --git-dir > /dev/null 2>&1; then
    echo ""
    echo " Git status:"
    git status --porcelain "$INDEX_FILE"
    echo ""
    echo " To commit changes:"
    echo "   git add $INDEX_FILE"
    echo "   git commit -m 'Update tech news index with $new_entries_added new entries'"
    echo "   git push"
fi
