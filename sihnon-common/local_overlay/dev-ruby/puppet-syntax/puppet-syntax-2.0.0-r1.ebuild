# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

USE_RUBY="ruby18 ruby19 ruby20 ruby21"

RUBY_FAKEGEM_TASK_TEST="none"
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="README.md CHANGELOG"
RUBY_FAKEGEM_EXTRAINSTALL="README.md CHANGELOG"

inherit ruby-fakegem

DESCRIPTION="Syntax checks for Puppet manifests and templates"
HOMEPAGE="https://github.com/gds-operations/puppet-syntax"

LICENSE="|| ( Ruby GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x64-macos ~x86-macos"
RDEPEND="|| ( app-admin/puppet app-admin/puppet-agent )"
DEPEND="${RDEPEND}
dev-ruby/rspec
dev-ruby/rake"
