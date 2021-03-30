#!/bin/bash
#Programa para probar los casos de prueba
red=$'\e[1;31m'
grn=$'\e[1;32m'
yel=$'\e[1;33m'
blu=$'\e[1;34m'
mag=$'\e[1;35m'
cyn=$'\e[1;36m'
end=$'\e[0m'
clear
for program in ./programas/*; do
  programName=$(basename $program)
  extension=${program##*.}

  #ignore files if name begins with "_"
  if [[ ${programName:0:1} != "_" ]]; then
    # cpp programs
    if [[ $extension == "cpp" ]]; then
      printf "${cyn}$programName${end} ${blu}(c++)${end}\n"
      clang++-7 -pthread -std=c++17 -o main $program
      if [ -e "main" ]; then
        for testFile in ./casos/*.in; do
          testFilename=$(basename $testFile .in)
          if [[ ${testFilename:0:1} != "_" ]] ; then
            printf "${yel}► $testFilename${end}\n"
            out=$(./main < $testFile)
            echo "$out"

            # compare with expected output (.out files)
            if [ -e "./casos/$testFilename.out" ]; then
              outputFilename="./casos/$testFilename.out"
              expected=$(cat $outputFilename)
              if [[ $out == $expected ]]; then
                printf "${grn}AC${end}"
              else
                printf "${red}WA${end}"
              fi
            fi
            printf "\n" 

          fi
        done
        rm ./main
      fi
      echo
    fi

    # python programs
    if [[ $extension == "py" ]]; then
      printf "${cyn}$programName${end} ${yel}(python)${end}\n"
      for testFile in ./casos/*.in; do
        testFilename=$(basename $testFile .in)
        if [[ ${testFilename:0:1} != "_" ]] ; then
          printf "${yel}► $testFilename${end}\n";  
          out=$(python $program < $testFile)
          echo "$out"

          # compare with expected output (.out files)
            if [ -e "./casos/$testFilename.out" ]; then
              outputFilename="./casos/$testFilename.out"
              expected=$(cat $outputFilename)
              if [[ $out == $expected ]]; then
                printf "${grn}AC${end}"
              else
                printf "${red}WA${end}"
              fi
            fi
            printf "\n\n" 

        fi
      done
    fi

  fi
done