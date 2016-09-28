#!/bin/bash
#
# Run all tests within the tests directory
#

test_dir="$(dirname $(readlink -f $BASH_SOURCE))"
tests_dir="${test_dir}/tests/"

mkdir -p /tmp/tmp
truncate -s 0 /tmp/tmp/output.log
chmod 777 /tmp/tmp/output.log
tail -f /tmp/tmp/output.log &

for file in `find ${tests_dir} -type f -name '*.bats'`; do
  file="$(echo $file | sed "s:${tests_dir}::")"
  $test_dir/run.sh $file

  if [[ "$?" -ne "0" ]]; then
    echo
    echo "! TEST FAILED !"
    echo
    echo "$file exited with a non-zero exit code."
    echo

    killall tail

    exit 1
  fi

done

killall tail

exit 0