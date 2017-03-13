name 'docker-platform'
maintainer 'Sam4Mobile'
maintainer_email 'dps.team@s4m.io'
license 'Apache 2.0'
description 'Use Docker ressources to install/configure Docker with attributes'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url 'https://gitlab.com/s4m-chef-repositories/docker-platform'
issues_url 'https://gitlab.com/s4m-chef-repositories/docker-platform/issues'
version '1.1.0'

supports 'centos', '>= 7.1'

depends 'consul-platform'
depends 'cluster-search'
depends 'docker'
