# go.sh Menu System for Hugo Blog

## Overview

Create a developer menu system for the Hugo blog similar to the existing `go.sh.example`, adapted for Hugo/website needs.

## Core Features (from existing example)

1. **gum-based menus** - Use `gum filter` for interactive selection
2. **"Run another command?"** - Default Yes after each action
3. **Dynamic script reloading** - Reload `shell_scripts/` functions on each menu load/selection

## Proposed Commands

| Command | Description |
|---------|-------------|
| Start Hugo server | Run `hugo server` with drafts |
| Build production site | Run `hugo --minify` |
| Create new blog post | Interactively prompt for title, create in `content/blogs/` |
| Preview deploy | Build and serve locally for testing |
| Deploy to GitHub Pages | Push to trigger CI/CD workflow |
| Clean build | Remove `public/` and `resources/` before building |
| List blog posts | Show all posts in `content/blogs/` |
| Open in browser | Open localhost:1313 |
| Exit | Quit the menu |

## File Structure

```
mywebsite/
├── go.sh                    # Main menu entry point
├── shell_scripts/
│   ├── _go_functions.sh     # All menu command functions
│   └── format_file.sh       # (keep from example)
└── ...existing hugo files...
```

## Implementation Plan

1. Create `shell_scripts/` directory
2. Create `shell_scripts/_go_functions.sh` with Hugo-specific functions
3. Create `go.sh` based on example, adapted for Hugo
4. Ensure `gum` dependency check
5. Test the menu system

## Function Structure in `_go_functions.sh`

```bash
# Main commands
hugo_server() { ... }
hugo_build() { ... }
create_blog_post() { ... }
hugo_preview() { ... }
deploy_github_pages() { ... }
hugo_clean() { ... }
list_blog_posts() { ... }
open_browser() { ... }

# Utility functions (from example)
print_and_execute() { ... }
all_done() { ... }
check_dependencies() { ... }
big_echo() { ... }
announce_and_run() { ... }
```
