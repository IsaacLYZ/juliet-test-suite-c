ulimit -c 0

SCRIPT_DIR=$(dirname $(realpath "$0"))
CWE_DIR=""
BINARY_DIR="bin"

if [ $# -ge 1 ]
then
  CWE_DIR="$1"
fi

if [ $# -ge 2 ]
then
  BINARY_DIR="$2"
fi

python "parse-cwe-status.py" "${SCRIPT_DIR}/${BINARY_DIR}/${CWE_DIR}/good.run" > "${CWE_DIR}_${BINARY_DIR}_good.txt"
python "parse-cwe-status.py" "${SCRIPT_DIR}/${BINARY_DIR}/${CWE_DIR}/bad.run" > "${CWE_DIR}_${BINARY_DIR}_bad.txt"
python "parse-cwe-status.py" "${SCRIPT_DIR}/${BINARY_DIR}/${CWE_DIR}/good_asan.run" > "${CWE_DIR}_${BINARY_DIR}_good_asan.txt"
python "parse-cwe-status.py" "${SCRIPT_DIR}/${BINARY_DIR}/${CWE_DIR}/bad_asan.run" > "${CWE_DIR}_${BINARY_DIR}_bad_asan.txt"