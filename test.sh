#!/bin/bash

ok_count=0
error_count=0

# Terminal color codes
if [ -t 1 ]; then
    green='\033[0;32m'
    red='\033[0;31m'
    no_color='\033[0m'
else
    green=''
    red=''
    no_color=''
fi

for file in $(find tests/ -name '*.core' -type f -print0 | xargs -0 du -b | sort -nr | cut -f2-); do
    file_name=$file
    echo -n "$file_name: "
    if tree-sitter parse "$file" 2>/dev/null | grep -q 'ERROR'; then
        echo -e "${red}ERROR${no_color}"
        ((error_count++))
    else
        echo -e "${green}OK${no_color}"
        ((ok_count++))
    fi
done

echo ""
echo -e "Total Passed: ${green}$ok_count${no_color}"
echo -e "Total Failed: ${red}$error_count${no_color}"

