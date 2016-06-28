# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

create_profile_links() {
  mkdir -p $(nos_etc_dir)/profile.d/
  nos_template \
    "links.sh.mustache" \
    "$(nos_etc_dir)/profile.d/links.sh" \
    "$(links_payload)"
}

links_payload() {
  cat <<-END
{
  "code_dir": "$(nos_code_dir)"
}
END
}

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

install_runtime() {
  nos_install "$(runtime)"
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
  nos_install "$(maven_runtime)"
}

maven_cache_dir() {
  [[ ! -f $(nos_code_dir)/.m2 ]] && nos_run_process "make maven cache dir" "mkdir -p $(nos_code_dir)/.m2"
  [[ ! -s ${HOME}/.m2 ]] && nos_run_process "link maven cache dir" "ln -s $(nos_code_dir)/.m2 ${HOME}/.m2"
}

maven_install() {
  (cd $(nos_code_dir); nos_run_process "maven install" "mvn -B -DskipTests=true clean install")
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