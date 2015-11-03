# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

create_boxfile() {
  template \
    "boxfile.mustache" \
    "-" \
    "$(boxfile_payload)"
}

boxfile_payload() {
  _has_bower=$(has_bower)
  if [[ "$_has_bower" = "true" ]]; then
    print_bullet_sub "Adding lib_dirs for bower"
  fi
  cat <<-END
{
  "java_home": "$(java_home)",
  "has_bower": ${_has_bower}
}
END
}

create_profile_links() {
  mkdir -p $(etc_dir)/profile.d/
  template \
    "links.sh.mustache" \
    "$(etc_dir)/profile.d/links.sh" \
    "$(links_payload)"
}

links_payload() {
  cat <<-END
{
  "live_dir": "$(live_dir)"
}
END
}

app_name() {
  # payload app
  echo "$(payload app)"
}

live_dir() {
  # payload live_dir
  echo $(payload "live_dir")
}

deploy_dir() {
  # payload deploy_dir
  echo $(payload "deploy_dir")
}

etc_dir() {
  echo $(payload "etc_dir")
}

env_dir() {
  echo $(payload 'env_dir')
}

code_dir() {
  echo $(payload "code_dir")
}

runtime() {
  echo $(validate "$(payload 'boxfile_runtime')" "string" "sun-jdk8")
}

condensed_runtime() {
  java_runtime="$(runtime)"
  echo ${java_runtime//[.-]/}
}

java_home() {
  case "$(runtime)" in
  sun-j[dk|re]8)
    echo "$(deploy_dir)/java/sun-8"
    ;;
  sun-j[dk|re]7)
    echo "$(deploy_dir)/java/sun-7"
    ;;
  sun-j[dk|re]6)
    echo "$(deploy_dir)/java/sun-6"
    ;;
  openjdk8)
    echo "$(deploy_dir)/java/openjdk8"
    ;;
  openjdk7)
    echo "$(deploy_dir)/java/openjdk7"
    ;;
  esac
}

install_runtime() {
  install "$(runtime)"
}

js_runtime() {
  echo $(validate "$(payload "boxfile_js_runtime")" "string" "nodejs-0.12")
}

install_js_runtime() {
  install "$(js_runtime)"
}

set_js_runtime() {
  [[ -d $(code_dir)/node_modules ]] && echo "$(js_runtime)" > $(code_dir)/node_modules/runtime
}

maven_default_version() {
  [[ "$(runtime)" = 'sun-jdk6' ]] && echo '3.2' || echo '3.3'
}

maven_version() {
  version="$(validate "$(payload "boxfile_maven_version")" "string" "$(maven_default_version)")"
  echo ${version//./}
}

maven_runtime() {
  echo $(validate "$(payload 'boxfile_maven_runtime')" "string" "$(condensed_runtime)-maven$(maven_version)")
}

install_maven() {
  install "$(maven_runtime)"
}

maven_cache_dir() {
  [[ ! -f $(code_dir)/.m2 ]] && run_subprocess "make maven cache dir" "mkdir -p $(code_dir)/.m2"
  [[ ! -s ${HOME}/.m2 ]] && run_subprocess "link maven cache dir" "ln -s $(code_dir)/.m2 ${HOME}/.m2"
}

maven_install() {
  (cd $(code_dir); run_subprocess "maven install" "mvn -B -DskipTests=true clean install")
}

create_database_url() {
  if [[ -n "$(payload 'env_POSTGRESQL1_HOST')" ]]; then
    persist_evar "DATABASE_URL" "postgres://$(payload 'env_POSTGRESQL1_USER'):$(payload 'env_POSTGRESQL1_PASS')@$(payload 'env_POSTGRESQL1_HOST'):$(payload 'env_POSTGRESQL1_PORT')/$(payload 'env_POSTGRESQL1_NAME')"
  fi
}