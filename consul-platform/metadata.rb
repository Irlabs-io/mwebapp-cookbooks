name 'consul-platform'
maintainer 'Sam4Mobile'
maintainer_email 'dps.team@s4m.io'
license 'Apache 2.0'
description 'Cookbook used to install and configure a consul cluster'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url 'https://gitlab.com/s4m-chef-repositories/consul-platform'
issues_url 'https://gitlab.com/s4m-chef-repositories/consul-paltform/issues'
version '1.0.0'

supports 'centos', '>= 7.1'

depends 'cluster-search'
depends 'ark'
