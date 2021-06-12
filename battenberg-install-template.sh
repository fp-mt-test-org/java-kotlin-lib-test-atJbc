#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

git_json="{\"git\":{\"owner\":\"${owner_name}\",\"name\":\"${project_name}\"}}"
echo "GIT JSON:"
echo "${git_json}"
echo

# This codeblock answers the prompts issued by battenberg below.
{
    if [[ -d "$HOME/.cookiecutters" ]]; then
        # You've downloaded .../.cookiecutters/template-java-kotlin-library before.
        # Is it okay to delete and re-download it? [yes]:
        echo "1";
        sleep 1;
    fi

    # owner [Product Infrastructure]:
    echo "Product Infrastructure";
    sleep 1;

    # component_id []:
    echo "${project_name}"
    sleep 1;

    # artifact_id [java-kotlin-lib-test-*****]:
    echo
    sleep 1;

    # storePath [https://github.com/fp-mt-test-org/java-kotlin-lib-test-*****]:
    echo
    sleep 1;

    # java_package_name [javakotlinlibtest*****]:
    echo
    sleep 1;

    # description [*****]:
    echo
    sleep 1;

    # destination [default]:
    echo "${git_json}"
    sleep 1;
} | battenberg install "${github_base_url}/${template_name}"
