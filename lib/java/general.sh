# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

java_create_boxfile() {
  nos_template \
    "boxfile.mustache" \
    "-" \
    "$(java_boxfile_payload)"
}

java_boxfile_payload() {
  _has_bower=$(nodejs_has_bower)
  if [[ "$_has_bower" = "true" ]]; then
    nos_print_bullet_sub "Adding lib_dirs for bower"
  fi
  cat <<-END
{
  "java_home": "$(java_home)",
  "has_bower": ${_has_bower}
}
END
}

java_create_profile_links() {
  mkdir -p $(nos_etc_dir)/profile.d/
  nos_template \
    "links.sh.mustache" \
    "$(nos_etc_dir)/profile.d/links.sh" \
    "$(java_links_payload)"
}

java_links_payload() {
  cat <<-END
{
  "live_dir": "$(nos_live_dir)"
}
END
}

java_env_dir() {
  echo $(nos_payload 'env_dir')
}

java_runtime() {
  echo $(nos_validate "$(nos_payload 'boxfile_runtime')" "string" "sun-jdk8")
}

java_condensed_runtime() {
  java_runtime="$(java_runtime)"
  echo ${java_runtime//[.-]/}
}

java_home() {
  case "$(java_runtime)" in
  sun-j??8)
    echo "$(nos_deploy_dir)/java/sun-8"
    ;;
  sun-j??7)
    echo "$(nos_deploy_dir)/java/sun-7"
    ;;
  sun-j??6)
    echo "$(nos_deploy_dir)/java/sun-6"
    ;;
  openjdk8)
    echo "$(nos_deploy_dir)/java/openjdk8"
    ;;
  openjdk7)
    echo "$(nos_deploy_dir)/java/openjdk7"
    ;;
  esac
}

java_install_runtime() {
  nos_install "$(java_runtime)"
}

java_maven_default_version() {
  [[ "$(java_runtime)" = 'sun-jdk6' ]] && echo '3.2' || echo '3.3'
}

java_maven_version() {
  version="$(nos_validate "$(nos_payload "boxfile_maven_version")" "string" "$(maven_default_version)")"
  echo ${version//./}
}

java_maven_runtime() {
  echo $(nos_validate "$(nos_payload 'boxfile_maven_runtime')" "string" "$(condensed_runtime)-maven$(maven_version)")
}

java_install_maven() {
  nos_install "$(java_maven_runtime)"
}

java_maven_cache_dir() {
  [[ ! -f $(nos_code_dir)/.m2 ]] && nos_run_subprocess "make maven cache dir" "mkdir -p $(nos_code_dir)/.m2"
  [[ ! -s ${HOME}/.m2 ]] && nos_run_subprocess "link maven cache dir" "ln -s $(nos_code_dir)/.m2 ${HOME}/.m2"
}

java_maven_install() {
  (cd $(nos_code_dir); nos_run_subprocess "maven install" "mvn -B -DskipTests=true clean install")
}

java_create_database_url() {
  if [[ -n "$(nos_payload 'env_POSTGRESQL1_HOST')" ]]; then
    nos_persist_evar "DATABASE_URL" "postgres://$(nos_payload 'env_POSTGRESQL1_USER'):$(nos_payload 'env_POSTGRESQL1_PASS')@$(nos_payload 'env_POSTGRESQL1_HOST'):$(nos_payload 'env_POSTGRESQL1_PORT')/$(nos_payload 'env_POSTGRESQL1_NAME')"
  fi
}