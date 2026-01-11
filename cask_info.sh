#!/bin/zsh

# I use the built-in Homebrew JSON API and system Ruby
# I fetch data about all installed casks at once
brew info --installed --cask --json=v2 | ruby -e "
  require 'json'
  
  # I parse the input data
  data = JSON.parse(STDIN.read)
  
  puts format('%-35s | %s', 'NAME (TOKEN)', 'DESCRIPTION')
  puts '-' * 80
  
  # I iterate through each cask from the JSON
  data['casks'].each do |cask|
    name = cask['token']
    # I retrieve the description and if missing I insert a placeholder
    desc = cask['desc'] || '---'
    
    # I display the formatted data
    puts format('%-35s | %s', name, desc)
  end
"