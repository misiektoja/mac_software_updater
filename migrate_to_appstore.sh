#!/bin/zsh

# I check if the mas CLI tool is installed before proceeding
if ! command -v mas &> /dev/null; then
    echo "Please install mas: brew install mas"
    exit 1
fi

# I fetch the list of all currently installed Homebrew casks
casks=($(brew list --cask))

for cask_token in "${casks[@]}"; do
    # I create a search query by replacing hyphens with spaces for better results
    search_query=$(echo "$cask_token" | tr '-' ' ')

    # I retrieve the first search result from the Mac App Store
    mas_result=$(mas search "$search_query" | head -n 1)

    if [[ -n "$mas_result" ]]; then
        # I extract the App Store ID and the full application name
        mas_id=$(echo "$mas_result" | awk '{print $1}')
        # I remove the ID and version brackets to get a clean name
        mas_name=$(echo "$mas_result" | sed -E 's/^[0-9]+ //; s/ \([0-9.]+\)$//')
        
        # I generate a preview link for manual verification
        mas_link="https://apps.apple.com/app/id$mas_id"

        echo ""
        echo "Local Cask: $cask_token"
        echo "App Store result: $mas_name (ID: $mas_id)"
        echo "Verification link: $mas_link"
        
        echo "Replace Homebrew version with App Store version? (y/n)"
        read -k 1 response
        echo ""

        if [[ "$response" == "y" || "$response" == "t" ]]; then
            echo "Removing $cask_token from Homebrew..."
            brew uninstall --cask "$cask_token"

            echo "Installing $mas_name from the App Store..."
            mas install "$mas_id"
            
            echo "Done"
        else
            echo "Skipped"
        fi
    fi
done