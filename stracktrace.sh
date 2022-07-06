# Sample code for generating a stack trace on catastrophic failure

set -E

trap 'ERRO_LINENO=$LINENO' ERR
trap '_failure' EXIT

_failure() {
   ERR_CODE=$? # capture last command exit code
   set +xv # turns off debug logging, just in case
   if [[  $- =~ e && ${ERR_CODE} != 0 ]] 
   then
       # only log stack trace if requested (set -e)
       # and last command failed
       echo
       echo "========= CATASTROPHIC COMMAND FAIL ========="
       echo
       echo "SCRIPT EXITED ON ERROR CODE: ${ERR_CODE}"
       echo
       LEN=${#BASH_LINENO[@]}
       for (( INDEX=0; INDEX<$LEN-1; INDEX++ ))
       do
           echo '---'
           echo "FILE: $(basename ${BASH_SOURCE[${INDEX}+1]})"
           echo "  FUNCTION: ${FUNCNAME[${INDEX}+1]}"
           if [[ ${INDEX} > 0 ]]
           then
		    # commands in stack trace
               echo "  COMMAND: ${FUNCNAME[${INDEX}]}"
               echo "  LINE: ${BASH_LINENO[${INDEX}]}"
           else
               # command that failed
               echo "  COMMAND: ${BASH_COMMAND}"
               echo "  LINE: ${ERRO_LINENO}"
           fi
       done
       echo
       echo "======= END CATASTROPHIC COMMAND FAIL ======="
       echo
   fi
}

# set working directory to this directory for duration of this test
cd "$(dirname ${0})"

echo 'Beginning stacktrace test'

set -e
source ./testfile1.sh
source ./testfile2.sh
set +e

_file1_function1
