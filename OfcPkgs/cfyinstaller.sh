#!/bin/bash
printf "\e[92mINSTALLING: cfy\n"

printf "\e[93mchecking lualibs\e[0m\n"
if ! command -v lua >/dev/null 2>&1; then
    pkg install lua54
fi

printf "\e[93mchecking cfy\e[0m"
if ! command -v cfy >/dev/null 2>&1; then
    cd ${PREFIX:-/usr}/bin
    printf "\e[92mpreparing to install cfylib.lua\e[0m\n"
    wget -O cfylib.lua https://raw.githubusercontent.com/tutugrande1235-DTD/DTD-Source-Scripts/main/OfcPkgs/cfylib.lua
    printf "\e[92mpreparing to install cfy\e[0m\n"
    wget -O cfy https://raw.githubusercontent.com/tutugrande1235-DTD/DTD-Source-Scripts/main/OfcPkgs/cfy
    printf "\e[92config executables\e[0m"
    chmod +x cfy
fi

cd ~

printf "\e[32m[PROCCESS COMPLETED | Press Enter]:\e[0m"
stty sane
stty -icanon -echo -isig
read
stty sane
cls
clear