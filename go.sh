#!/bin/bash
echo "=============================================="
echo "=== starting Hugo Blog menu system... ==="
echo "=============================================="
echo

show_menu() {
    choice=$(echo -e "Start Hugo server\nBuild production site\nCreate new blog post\nPreview deploy\nDeploy to GitHub Pages\nClean build\nList blog posts\nOpen in browser\nQuit" | gum filter --placeholder "Choose an option..." --indicator="➜ ")

    case $choice in
        "Start Hugo server") print_and_execute "Starting Hugo server..." hugo_server ;;
        "Build production site") print_and_execute "Building production site..." hugo_build ;;
        "Create new blog post") print_and_execute "Creating new blog post..." create_blog_post ;;
        "Preview deploy") print_and_execute "Previewing deploy..." hugo_preview ;;
        "Deploy to GitHub Pages") print_and_execute "Deploying to GitHub Pages..." deploy_github_pages ;;
        "Clean build") print_and_execute "Cleaning build..." hugo_clean ;;
        "List blog posts") print_and_execute "Listing blog posts..." list_blog_posts ;;
        "Open in browser") print_and_execute "Opening in browser..." open_browser ;;
        "Quit") echo "Goodbye!"; exit 0 ;;
    esac
}

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

    show_menu
}

check_dependencies
