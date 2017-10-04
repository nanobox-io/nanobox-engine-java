# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

env_dir() {
  echo $(nos_payload 'env_dir')
}

runtime() {
  echo $(nos_validate "$(nos_payload 'config_runtime')" "string" "oracle-jdk8")
}

condensed_runtime() {
  runtime="$(runtime)"
  echo ${runtime//[.-]/}
}

java_home() {
  case "$(runtime)" in
  oracle-j??8)
    echo "$(nos_data_dir)/java/oracle-8"
    ;;
  sun-j??7)
    echo "$(nos_data_dir)/java/sun-7"
    ;;
  sun-j??6)
    echo "$(nos_data_dir)/java/sun-6"
    ;;
  openjdk8)
    echo "$(nos_data_dir)/java/openjdk8"
    ;;
  openjdk7)
    echo "$(nos_data_dir)/java/openjdk7"
    ;;
  esac
}

java_env() {
  if [[ ! -f "$(nos_etc_dir)/env.d/JAVA_HOME" ]]; then
    echo "$(java_home)" > "$(nos_etc_dir)/env.d/JAVA_HOME"
  fi
  if [[ ! -f "$(nos_etc_dir)/env.d/JAVA_OPTS" ]]; then
    echo "-XX:+UseCompressedOops" > "$(nos_etc_dir)/env.d/JAVA_OPTS"
  fi
  if [[ ! -f "$(nos_etc_dir)/env.d/PORT" ]]; then
    echo "8080" > "$(nos_etc_dir)/env.d/PORT"
  fi
}

install_runtime() {
  pkgs=($(runtime))

  nos_install ${pkgs[@]}
}

# Uninstall build dependencies
uninstall_build_packages() {
  pkgs=()

  # if pkgs isn't empty, let's uninstall what we don't need
  if [[ ${#pkgs[@]} -gt 0 ]]; then
    nos_uninstall ${pkgs[@]}
  fi
}

is_maven() {
  [ -n "$(nos_payload 'config_maven_version')" ]
}
maven_default_version() {
  [[ "$(runtime)" = 'sun-jdk6' ]] && echo '3.2' || echo '3.3'
}

maven_version() {
  version="$(nos_validate "$(nos_payload "config_maven_version")" "string" "$(maven_default_version)")"
  echo ${version//./}
}

maven_runtime() {
  echo $(nos_validate "$(nos_payload 'config_maven_runtime')" "string" "$(condensed_runtime)-maven$(maven_version)")
}

install_maven() {
  is_maven && nos_install "$(maven_runtime)"
}

maven_process_resources() {
  is_maven && (cd $(nos_code_dir); nos_run_process "maven process-resources" "mvn -T 4.0C -B -DskipTests=true clean process-resources")
}

maven_install() {
  is_maven && (cd $(nos_code_dir); nos_run_process "maven install" "mvn -T 4.0C -B -DskipTests=true clean install")
}

is_gradle() {
  [ -n "$(nos_payload 'config_gradle_version')" ]
}

check_gradle_version() {
  if [[ -z "$(wget -S --spider https://services.gradle.org/distributions/gradle-$(gradle_version)-bin.zip 2>&1 | grep 'HTTP/1.1 200 OK')" ]]; then
    nos_print_fatal "Invalid Gradle Version"  "$(gradle_version) is not a valid Gradle version. Please check  https://gradle.org/releases/ for valid versions."
    exit 1
  fi
}

gradle_version() {
  echo $(nos_validate "$(nos_payload "config_gradle_version")" "string" "")
}

download_gradle() {
  check_gradle_version
  nos_install "unzip"
  wget -qO /tmp/gradle.zip https://services.gradle.org/distributions/gradle-$(gradle_version)-bin.zip
  unzip -qo /tmp/gradle.zip -d /tmp
  rsync -a /tmp/gradle-$(gradle_version)/. /data/
}

install_gradle() {
  is_gradle && download_gradle
}

gradle_config_build() {
  echo $(nos_validate "$(nos_payload "config_gradle_build")" "string" "gradle build")
}

gradle_build() {
  is_gradle && (cd $(nos_code_dir); nos_run_process "gradle build" "$(gradle_config_build)")
}

# Copy the code into the live directory which will be used to run the app
publish_release() {
  nos_print_bullet "Moving build into live code directory..."
  rsync -a $(nos_code_dir)/ $(nos_app_dir)
}

create_database_url() {
  if [[ -n "$(nos_payload 'env_POSTGRESQL1_HOST')" ]]; then
    nos_persist_evar "DATABASE_URL" "postgres://$(nos_payload 'env_POSTGRESQL1_USER'):$(nos_payload 'env_POSTGRESQL1_PASS')@$(nos_payload 'env_POSTGRESQL1_HOST'):$(nos_payload 'env_POSTGRESQL1_PORT')/$(nos_payload 'env_POSTGRESQL1_NAME')"
  fi
}
