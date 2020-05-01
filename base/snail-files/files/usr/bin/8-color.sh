#!/bin/bash


# Color Code for tput:

clear
echo
cat <<-EOT
# 0 – Black
# 1 – Red
# 2 – Green
# 3 – Yellow
# 4 – Blue
# 5 – Magenta
# 6 – Cyan
# 7 – White
EOT


echo
printf $(tput setaf 2; tput bold)'Color Show\n'$(tput sgr0)
printf $(tput setaf 2)'Color Show\n'$(tput sgr0)
echo


for((i=0; i<=7; i++)); do
    echo "${i}: "$(tput setaf $i)"Show me the money"$(tput sgr0)
done

printf '\n'$(tput setaf 2; tput setab 0; tput bold)'Background color show'$(tput sgr0)'\n\n'

for((i=0,j=7; i<=7; i++,j--)); do
    echo "${i}: "$(tput setaf $i; tput setab $j; tput bold)"Show me the money"$(tput sgr0)
done

exit 0


