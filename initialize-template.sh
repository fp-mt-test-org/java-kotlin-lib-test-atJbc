#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

if [[ $CI ]]; then
    git config user.name "CI"
    git config user.email "ci@ci.com"
fi

template_context_file='.cookiecutter.json'
install_script='battenberg-install-template.sh'
initialize_template_script='initialize-template.sh'

battenberg_output=$(./${install_script} 2>&1 || true)

echo "${battenberg_output}"

cat "${template_context_file}"

# The "|| true" above is to prevent this script from failing
# in the event that initialize-template.sh fails due to errors,
# such as merge conflicts.

echo
echo "Checking for MergeConflictExceptions..."
echo
if [[ "${battenberg_output}" =~ "MergeConflictException" ]]; then
    
    echo "Merge Conflict Detected, attempting to resolve!"

    # Remove all instances of:
    # <<<<<<< HEAD
    # ...
    # =======
    
    # And

    # Remove all instances of:
    # >>>>>>> 0000000000000000000000000000000000000000
    
    cookiecutter_json_updated=$(cat ${template_context_file} | \
        perl -0pe 's/<<<<<<< HEAD[\s\S]+?=======//gms' | \
        perl -0pe 's/>>>>>>> [a-z0-9]{40}//gms')

    echo "${cookiecutter_json_updated}" > "${template_context_file}"
    echo
    cat "${template_context_file}"
    echo
    echo "Conflicts resolved, committing..."
    git add "${template_context_file}"
    git commit -m "fix: Resolved merge conflicts with template."
else
    echo "No merge conflicts detected."
    exit 1
fi

echo
cat "${template_context_file}"

echo
echo "Removing template initialization scripts that are no longer needed..."
rm "${install_script}"
rm "${initialize_template_script}"
echo "Done!"
echo

echo "Committing..."
git add "${install_script}"
git add "${initialize_template_script}"
git commit -m "Removes template initialization scripts that are no longer needed."

echo "Pushing template and main branches to remote..."
git push origin template
git push origin master
