
#### Menu Functions called by `go.sh`

hugo_server() {
    big_echo "Starting Hugo development server..."
    export PATH="$HOME/bin:$PATH"
    hugo server -D --bind 0.0.0.0
}

hugo_build() {
    big_echo "Building production site..."
    export PATH="$HOME/bin:$PATH"
    hugo --minify
    check_error "Hugo build" || return 1
}

create_blog_post() {
    title=$(gum input --placeholder "Enter blog post title")

    if [ -z "$title" ]; then
        echo "Title cannot be empty."
        return 1
    fi

    slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -d '?!.,')

    filename="content/blogs/${slug}.md"

    if [ -f "$filename" ]; then
        echo "File $filename already exists."
        return 1
    fi

    date=$(date +%Y-%m-%d)

    cat > "$filename" << EOF
---
title: "$title"
date: $date
draft: true
---

Write your content here...
EOF

    big_echo "Created blog post: $filename"
    echo "Edit it with: vim $filename"
}

hugo_preview() {
    big_echo "Building and previewing site..."
    export PATH="$HOME/bin:$PATH"
    rm -rf public
    hugo --minify
    check_error "Hugo build" || return 1

    echo ""
    echo "Serving preview at http://localhost:1414"
    python3 -m http.server 1414 --directory public &
    SERVER_PID=$!

    gum style --foreground "green" "Preview server running on http://localhost:1414"
    echo "Press Ctrl+C to stop the preview server"

    trap "kill $SERVER_PID 2>/dev/null" EXIT
    wait $SERVER_PID
}

deploy_github_pages() {
    big_echo "Deploying to GitHub Pages..."

    if gum confirm "Push to main to trigger GitHub Pages deployment?" --default=Yes; then
        git push origin main
        check_error "Git push" || return 1

        gum style --foreground "green" "✔  Pushed to main. GitHub Actions will deploy shortly."
        echo "Check status at: https://github.com/$(git remote get-url origin | sed 's/.*github.com[/:]//' | sed 's/.git$//')/actions"
    else
        echo "Deployment cancelled."
    fi
}

hugo_clean() {
    big_echo "Cleaning build directories..."
    rm -rf public
    rm -rf resources
    gum style --foreground "green" "✔  Cleaned public/ and resources/"
}

list_blog_posts() {
    echo "Blog posts in content/blogs/:"
    echo ""
    for f in content/blogs/*.md; do
        if [ -f "$f" ]; then
            title=$(head -5 "$f" | grep "^title:" | sed 's/title: //' | tr -d '"')
            date=$(head -5 "$f" | grep "^date:" | sed 's/date: //')
            filename=$(basename "$f")
            echo "  - $filename"
            echo "    Title: $title"
            echo "    Date: $date"
            echo ""
        fi
    done
}

open_browser() {
    if command -v xdg-open > /dev/null 2>&1; then
        xdg-open http://localhost:1313
    elif command -v open > /dev/null 2>&1; then
        open http://localhost:1313
    else
        echo "Cannot auto-open browser. Navigate to http://localhost:1313"
    fi
}

quit() {
    echo "Goodbye!"
    exit 0
}


#### Utility functions

print_and_execute() {
    local description="$1"
    local command="$2"
    local go_functions_file="./shell_scripts/_go_functions.sh"

    if [[ -f "$go_functions_file" ]]; then
        source "$go_functions_file"
    else
        echo "Error: Functions file '$go_functions_file' not found."
        return 1
    fi

    extra_big_echo "$description"

    if declare -F "$command" > /dev/null; then
        $command
        all_done
    else
        echo "Error: Command '$command' not found in '$go_functions_file'."
        return 1
    fi
}

extra_big_echo() {
    local message=$1
    gum style \
    --foreground 212 --border-foreground 212 --border double \
    --align center --width 50 --margin "1 2" --padding "1 2" \
    "$message"
}

all_done() {
    echo
    gum style --foreground "green" "✔  All done."
    echo

    if gum confirm "Run another command?" --default=Yes; then
        show_menu
    else
        echo "Exiting..."
        exit 0
    fi
}

check_dependencies() {
    echo
    echo "--- Checking dependencies..."
    echo

    echo "...checking for 'gum'..."
    if ! command -v gum > /dev/null 2>&1; then
        echo "gum is not installed."
        echo "Please install gum by following the instructions below:"
        echo
        echo "On Debian-based Linux (Ubuntu, etc.):"
        echo "sudo mkdir -p /etc/apt/keyrings"
        echo "curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg"
        echo "echo 'deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *' | sudo tee /etc/apt/sources.list.d/charm.list"
        echo "sudo apt update && sudo apt install gum"
        echo
        echo "On macOS using Homebrew:"
        echo "brew install gum"
        return 1
    else
        echo "gum is installed."
    fi

    echo
    echo "all pre-checks complete!"
    echo
}

check_error() {
    local exit_code=$?
    local message="$1"

    if [ $exit_code -ne 0 ]; then
        echo -e "\e[31mError: $message\e[0m"
        return $exit_code
    fi

    echo -e "\e[32mSuccess: $message\e[0m"
}

big_echo() {
    local message=$1
    gum style \
    --border-foreground 240 --border normal \
    --align center --width 50 --margin "1 2"\
    "$message"
}
