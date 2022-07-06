_file1_function1() {
    echo
    echo "executing in _file1_function1"

    _file2_function1
}

# adsfadfaf

_file1_function2() {
    echo
    echo "executing in _file1_function2"
    
    set -e
    #curl this_curl_will_fail_and_CAUSE_A_STACK_TRACE

    # function never called
    _file2_does_not_exist
    set +e
}