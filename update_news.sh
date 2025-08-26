#!/bin/bash

# Script to update tech news index.md with new HTML files
# Usage: ./update_tech_index.sh [directory]

cp ../scrape-news/*html all-things-tech/

# Set default directory to current working directory if not provided
TECH_DIR="${1:-$(pwd)}"

# Check if we're in the right directory structure
if [[ ! -d "$TECH_DIR/all-things-tech" ]]; then
    echo "❌ Error: all-things-tech directory not found in $TECH_DIR"
    echo "Usage: $0 [path_to_github_pages_directory]"
    echo "Example: $0 /path/to/anish7605.github.io"
    exit 1
fi

INDEX_FILE="$TECH_DIR/all-things-tech/index.md"
TECH_NEWS_DIR="$TECH_DIR/all-things-tech"

# Check if index.md exists
if [[ ! -f "$INDEX_FILE" ]]; then
    echo "❌ Error: $INDEX_FILE not found"
    exit 1
fi

echo "🔍 Scanning for new tech news HTML files in $TECH_NEWS_DIR..."

# Find all HTML files that match the pattern tech_news_*.html
html_files=($(find "$TECH_NEWS_DIR" -name "tech_news_*.html" -o -name "tech_news_security_*.html" -o -name "combined_news_*.html" | sort -r))

if [[ ${#html_files[@]} -eq 0 ]]; then
    echo "ℹ️  No tech news HTML files found"
    exit 0
fi

echo "📄 Found ${#html_files[@]} HTML file(s)"

# Create a backup of the current index.md
cp "$INDEX_FILE" "$INDEX_FILE.backup.$(date +%Y%m%d_%H%M%S)"
echo "💾 Created backup: $INDEX_FILE.backup.$(date +%Y%m%d_%H%M%S)"

# Read the current index.md and extract existing entries
existing_entries=()
while IFS= read -r line; do
    if [[ "$line" =~ ^\-[[:space:]]*\[.*\]\(.*\.html\) ]]; then
        # Extract the filename from the markdown link
        filename=$(echo "$line" | sed -n 's/.*(\([^)]*\.html\)).*/\1/p' | xargs basename)
        existing_entries+=("$filename")
    fi
done < "$INDEX_FILE"

echo "📋 Found ${#existing_entries[@]} existing entries in index"

# Process each HTML file
new_entries_added=0
temp_entries=()

for html_file in "${html_files[@]}"; do
    filename=$(basename "$html_file")
    
    # Skip if entry already exists
    if printf '%s\n' "${existing_entries[@]}" | grep -q "^$filename$"; then
        echo "⏭️  Skipping $filename (already in index)"
        continue
    fi
    
    echo "🆕 Processing new file: $filename"
    
    url_path="tech-news"
    # Extract date from filename
    if [[ "$filename" =~ tech_news_security_([0-9]{8})_[0-9]{6}\.html ]]; then
        # Security news file
        date_str="${BASH_REMATCH[1]}"
        file_type="🔒 Security"
    elif [[ "$filename" =~ combined_news_report_([0-9]{8})_[0-9]{6}\.html ]]; then
        # Combined news file
        date_str="${BASH_REMATCH[1]}"
        file_type="🔄 Combined"
    elif [[ "$filename" =~ tech_news_([0-9]{8})_[0-9]{6}\.html ]]; then
        # Regular tech news file
        date_str="${BASH_REMATCH[1]}"
        file_type="🚀 Tech"
    else
        echo "⚠️  Warning: Cannot parse date from $filename, skipping"
        continue
    fi
    
    # Convert YYYYMMDD to MM-DD-YYYY format
    if [[ "$date_str" =~ ^([0-9]{4})([0-9]{2})([0-9]{2})$ ]]; then
        year="${BASH_REMATCH[1]}"
        month="${BASH_REMATCH[2]}"
        day="${BASH_REMATCH[3]}"
        formatted_date="$month-$day-$year"
        display_date="$month/$day/$year"
    else
        echo "⚠️  Warning: Invalid date format in $filename, skipping"
        continue
    fi
    
    # Create the new entry
    new_entry="- [$file_type $display_date](https://anish7600.github.io/$url_path/$filename)"
    temp_entries+=("$new_entry")
    
    echo "✅ Prepared entry: $file_type $display_date"
    ((new_entries_added++))
done

# If no new entries, exit
if [[ $new_entries_added -eq 0 ]]; then
    echo "ℹ️  No new entries to add"
    rm "$INDEX_FILE.backup.$(date +%Y%m%d_%H%M%S)" 2>/dev/null
    exit 0
fi

# Update the index.md file
echo "📝 Updating $INDEX_FILE with $new_entries_added new entries..."

# Create new index content
{
    # Read until we find the ## Tech News line
    while IFS= read -r line; do
        echo "$line"
        if [[ "$line" == "## Tech News" ]]; then
            break
        fi
    done < "$INDEX_FILE"
    
    # Add empty line after header
    echo ""
    
    # Add new entries (most recent first)
    for entry in "${temp_entries[@]}"; do
        echo "$entry"
    done
    
    # Add existing entries
    while IFS= read -r line; do
        if [[ "$line" =~ ^\-[[:space:]]*\[.*\]\(.*\.html\) ]]; then
            echo "$line"
        fi
    done < "$INDEX_FILE"
    
} > "$INDEX_FILE.tmp"

# Replace the original file
mv "$INDEX_FILE.tmp" "$INDEX_FILE"

echo "✅ Successfully updated $INDEX_FILE"
echo "📊 Summary:"
echo "   • Added: $new_entries_added new entries"
echo "   • Total HTML files: ${#html_files[@]}"
echo "   • Backup saved: $INDEX_FILE.backup.*"

# Show the updated content
echo ""
echo "📄 Updated index content:"
echo "========================"
tail -n +1 "$INDEX_FILE" | grep -E "(^## Tech News|^- \[)"

# Optional: Show git status if we're in a git repo
if git rev-parse --git-dir > /dev/null 2>&1; then
    echo ""
    echo "📋 Git status:"
    git status --porcelain "$INDEX_FILE"
    echo ""
    echo "💡 To commit changes:"
    echo "   git add $INDEX_FILE"
    echo "   git commit -m 'Update tech news index with $new_entries_added new entries'"
    echo "   git push"
fi
