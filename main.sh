#!/bin/bash
#Programa para probar los casos de prueba

showCases=true # Muestra detalles los casos de prueba
showResults=true # Muestra la salida de los programas
showTime=false # Muestra el tiempo tltal
timePrecision=5  # Número de decimales [0, 9]

# - Jorge Arreola

clear
bla=$'\e[1;30m'; gray=$'\e[1;90m'
red=$'\e[1;31m'; lred=$'\e[1;91m'
grn=$'\e[1;32m'; lgrn=$'\e[1;92m'
yel=$'\e[1;33m'; lyel=$'\e[1;93m'
blu=$'\e[1;34m'; lblu=$'\e[1;94m'
mag=$'\e[1;35m'; lmag=$'\e[1;95m'
cyn=$'\e[1;36m'; lcyn=$'\e[1;96m'
end=$'\e[0m'   ; whit=$'\e[1;97m'

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
        totalTime=0
        ac=true

        for testFile in ./casos/*.in; do
          testFilename=$(basename $testFile .in)
          if [[ ${testFilename:0:1} != "_" ]] ; then
            if [ $showCases == true ] ; then 
              printf "${yel}► $testFilename${end} "; 
            fi

            STARTTIME=$(date '+%s%N')
            out=$(./main < $testFile)
            ENDTIME=$(date '+%s%N')
            testDuration=$((ENDTIME-STARTTIME))
            #echo $testDuration
            totalTime=$(($totalTime+$testDuration))

            if [ $showResults == true ] ; then  
              printf "\n$out\n"; 
            fi

            # compare with expected output (.out files)
            if [ -e "./casos/$testFilename.out" ]; then
              outputFilename="./casos/$testFilename.out"
              expected=$(cat $outputFilename)
              if [[ $out == $expected ]]; then
                if [ $showCases == true ] ; then printf "${grn}AC${end}"; fi
              else
                if [ $showCases == true ] ; then printf "${red}WA${end}"; fi
                ac=false
              fi
            fi

            if [ $showCases == true ] ; then printf "\n"; fi

          fi
        done
        
        if [ $showCases == false ] ; then
          if [ $ac == true ] ; then
            printf "${grn}AC${end} ";
          else
            printf "${red}WA${end} ";
          fi
        fi

        if [ $showTime == true ] ; then
          precision="%0."$timePrecision"f"
          command=$"echo print((tonumber(string.format('$precision', $totalTime/1000000000)))..'s')"
          $command | lua
        fi

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
          printf "${yel}► $testFilename${end} ";  
          out=$(python $program < $testFile)
          if [ $showResults == true ] ; then  printf "\n$out\n"; fi

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

    # javascript programs
    runNodePath='./helpers/run.js'
    if [[ $extension == "js" ]]; then
      printf "${cyn}$programName${end} ${lyel}(javascript)${end}\n"
      for testFile in ./casos/*.in; do
        testFilename=$(basename $testFile .in)
        if [[ ${testFilename:0:1} != "_" ]] ; then
          printf "${yel}► $testFilename${end} ";  
          out=$(node $runNodePath $program $testFile)
          if [ $showResults == true ] ; then  printf "\n$out\n"; fi

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