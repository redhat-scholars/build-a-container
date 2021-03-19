interrupt() {
  cleanup 130
}

error() {
  local ret=$?
  echo "[$0] An error occured during the execution of the script"
  cleanup ${ret}
}

cleanup() {
  local ret="${1:-${?}}"

  echo "Finishing with return value of ${ret}"
  exit "${ret}"
}