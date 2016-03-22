#!/bin/bash

. /vagrant/scripts/functions.sh

export REPOSITORY_DESCRIPTION="Sihnon common packages"

BUILD_ARGS=(
    "app-admin/librarian-puppet"
    "app-admin/puppet-agent"
    "app-admin/puppet-lint"
    "app-vim/puppet-syntax"
    "dev-ruby/hiera-eyaml-gpg"
    "dev-ruby/puppet-syntax"
    "dev-ruby/puppet_forge"
    "dev-util/jenkins-bin"
    "net-analyzer/nagios-plugins"
    "net-misc/openssh"
    "net-misc/pssh"
    "sys-auth/google-authenticator"
    "sys-auth/nss_ldap"
    "sys-auth/nss_updatedb"
    #"sys-auth/pam_ccreds" # Currently broken
    "sys-auth/pam_ldap"
    "sys-fs/zfs-auto-snapshot"
    "--remove app-admin/puppet"
    "--remove app-emulation/virt-what"
    "--remove dev-ruby/facter"
    "--remove dev-ruby/hiera"
    "--layman gentoo-zh"
    "--layman swegener"
)

build_all "${BUILD_ARGS[@]}"
