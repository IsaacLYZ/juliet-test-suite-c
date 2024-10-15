#!/bin/sh

# the first parameter specifies a CWE binary entry directory
# the second parameter specifies a non-default timeout duration

# this script will run all good and bad tests in the bin subdirectory and write
# the names of the tests and their return codes into the files "good.run" and
# "bad.run". all tests are run with a timeout so that tests requiring input
# terminate quickly with return code 124.

ulimit -c 0

SCRIPT_DIR=$(dirname $(realpath "$0"))
TIMEOUT="1s"
CWE_DIR=""
INPUT_FILE="/tmp/in.txt"

cat "abcdefg" > "/tmp/in.txt"

# We have to disable leak sanitizer to conduct the experiment
# TODO: we could probably fix this
ASAN_OPTIONS=detect_leaks=0

if [ $# -ge 1 ]
then
  CWE_DIR="$1"
fi

if [ $# -ge 2 ]
then
  TIMEOUT="$2"
fi

# parameter 1: the CWE directory corresponding to the tests
# parameter 2: the type of tests to run (should be "good" or "bad")
run_tests()
{
  local CWE_DIRECTORY="$1"
  local TEST_TYPE="$2"
  local TYPE_PATH="${CWE_DIRECTORY}/${TEST_TYPE}"

  local PREV_CWD=$(pwd)
  cd "${CWE_DIRECTORY}" # change directory in case of test-produced output files

  echo "========== STARTING TEST ${TYPE_PATH} $(date) ==========" >> "${TYPE_PATH}.run"
  for TESTCASE in $(ls -1 "${TYPE_PATH}"); do
    local TESTCASE_PATH="${TYPE_PATH}/${TESTCASE}"
    timeout "${TIMEOUT}" "${TESTCASE_PATH}" < "${INPUT_FILE}"
    echo "${TESTCASE_PATH} $?" >> "${TYPE_PATH}.run"
  done

  cd "${PREV_CWD}"
}

run_tests "${SCRIPT_DIR}/${CWE_DIR}" "good"
#run_tests "${SCRIPT_DIR}/${CWE_DIR}" "good_asan"
run_tests "${SCRIPT_DIR}/${CWE_DIR}" "bad"
#run_tests "${SCRIPT_DIR}/${CWE_DIR}" "bad_asan"
