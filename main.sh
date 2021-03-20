#!/bin/bash
#Programa para probar los casos de prueba
yel=$'\e[1;33m'
cyn=$'\e[1;36m'
end=$'\e[0m'
clear
for program in ./*.cpp; do
  printf "${cyn}$program${end}\n"
  clang++-7 -pthread -std=c++17 -o main $program
  for filepath in ./casos/*.txt; do
    filename=$(basename $filepath .txt)
    printf "${yel}► $filename${end}\n";  
    ./main < $filepath
    printf "\n" ;
  done
  echo;
done