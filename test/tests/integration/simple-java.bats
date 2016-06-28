# Integration test for a simple java app

# source environment helpers
. util/env.sh

payload() {
  cat <<-END
{
  "code_dir": "/tmp/code",
  "data_dir": "/data",
  "app_dir": "/tmp/app",
  "cache_dir": "/tmp/cache",
  "etc_dir": "/data/etc",
  "env_dir": "/data/etc/env.d",
  "config": {}
}
END
}

setup() {
  # cd into the engine bin dir
  cd /engine/bin
}

@test "setup" {
  # prepare environment (create directories etc)
  prepare_environment

  # prepare pkgsrc
  run prepare_pkgsrc

  # create the code_dir
  mkdir -p /tmp/code

  # copy the app into place
  cp -ar /test/apps/simple-java/* /tmp/code

  if [ -d /tmp/cache/target ]; then
    rsync -a /tmp/cache/target/ /tmp/code/target
  fi

  if [ -d /tmp/cache/.m2 ]; then
    rsync -a /tmp/cache/.m2/ /tmp/code/.m2
  fi

  run pwd

  [ "$output" = "/engine/bin" ]
}

@test "boxfile" {
  run /engine/bin/boxfile "$(payload)"

  echo "$output"

  [ "$status" -eq 0 ]
}

@test "prepare" {
  run /engine/bin/prepare "$(payload)"

  echo "$output"

  [ "$status" -eq 0 ]
}

@test "compile" {
  run /engine/bin/compile "$(payload)"

  echo "$output"

  [ "$status" -eq 0 ]
}

@test "cleanup" {
  run /engine/bin/cleanup "$(payload)"

  echo "$output"

  [ "$status" -eq 0 ]
}

@test "release" {

  if [ -d /tmp/code/target ]; then
    rsync -a --delete /tmp/code/target/ /tmp/cache/target
  fi

  if [ -d /tmp/code/.m2 ]; then
    rsync -a --delete /tmp/code/.m2/ /tmp/cache/.m2
  fi

  run /engine/bin/release "$(payload)"

  echo "$output"

  [ "$status" -eq 0 ]
}

@test "verify" {
  # remove the code dir
  rm -rf /tmp/code

  # mv the app_dir to code_dir
  mv /tmp/app /tmp/code

  # cd into the app code_dir
  cd /tmp/code

  # start the server in the background
  /data/java/oracle-8/bin/java -jar /tmp/code/target/helloworld-jar-with-dependencies.jar &

  # grab the pid
  pid=$!

  # sleep a few seconds so the server can start
  sleep 3

  # curl the index
  run curl -s 127.0.0.1:4567/hello 2>/dev/null

  expected="Hello World!"

  # kill the server
  kill -9 $pid > /dev/null 2>&1

  echo "$output"

  [ "$output" = "$expected" ]
}
