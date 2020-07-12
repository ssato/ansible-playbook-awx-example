#! /usr/bin/bats
#
# Requirements:
#   - bats: https://github.com/sstephenson/bats
#
function setup () {
    export INVENTORY=${1:-hosts.yml}
    cd $BATS_TEST_DIRNAME
}

function check_results () {
    [[ ${status} -eq 0 ]] || {
        cat << EOM
output:
${output}
EOM
        exit ${status}
    }
}

# @test "Lint files" {
#     run ansible-lint playbook.yml
#     check_results
# }

@test "Test install ansible roles using ansible-galaxy" {
    roles_dir=$(mktemp -d)

    cd ..  # move to topdir

    run ansible-galaxy install -p ${roles_dir:?} -r roles/requirements.yml
    check_results

    for rdir in $(sed -nr 's/^  name: //p' roles/*requirements.yml)
    do
        run test -d ${roles_dir}/${rdir}
        check_results
    done

    [[ "${roles_dir}" == "/" ]] || rm -rf ${roles_dir}
}

# vim:sw=4:ts=4:et:filetype=sh:
