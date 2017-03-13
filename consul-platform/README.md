Consul Platform
=============

Description
-----------

[Consul](https://www.hashicorp.com/consul.html) is a completely distributed,
highly available, and datacenter aware solution for service discovery.

Requirements
------------

### Cookbooks and gems

Declared in [metadata.rb](metadata.rb) and in [Gemfile](Gemfile).

### Platforms

A *systemd* managed distribution:
- RHEL Family 7, tested on Centos

Usage
-----

### Test

This cookbook is fully tested through the installation of a working 3-nodes
cluster in docker hosts. This uses kitchen, docker and some monkey-patching.

### Easy Setup

Set `node['consul-platform']['hosts']` to an array containing the
hostnames of the nodes of the consul cluster

### Search

The recommended way to use this cookbook is through the creation of a role per
**consul** cluster. This enables the search by role feature, allowing a
simple service discovery.

In fact, there are two ways to configure the search:

1. With a static configuration through a list of hostnames (attributes `hosts`
   that is `node['consul-platform']['hosts']`) for nodes belonging to
   consul cluster.
2. With a real search, performed on a role (attributes `role` and `size`
   like in `node['consul-platform']['role']`).
   The role should be in the run-list of all nodes of the cluster.
   The size is a safety and should be the number of nodes of this role.

If hosts is configured, `role` and `size` are ignored

See [roles](test/integration/roles) for some examples and
[Cluster Search][cluster-search] documentation for more information.

### Test

This cookbook is fully tested through the installation of a working 3-nodes
cluster in docker hosts. This uses kitchen, docker and some monkey-patching.

For more information, see [.kitchen.yml](.kitchen.yml) and [test](test)
directory.


Attributes
----------

Configuration is done by overriding default attributes. All configuration keys
have a default defined in [attributes/default.rb](attributes/default.rb).
Please read it to have a comprehensive view of what and how you can configure
this cookbook behavior.

Recipes
-------

### default

Include `search`, `user`, `install`, `config` and `systemd` recipes.

### search

Search the node (initiator) that will initialize first the consul cluster
using [Cluster Search][cluster-search].

Other nodes will join the consul cluster after the initiator using its
address.

### user

Create user/group used by consul.

### install

Install consul using ark.

### config

Generate options for the consul node.

Global options for each consul node in the cluster are defined through
the following attribute: `node['consul-platform']['options']`.

### systemd

Create systemd service file for consul.

Changelog
---------

Available in [CHANGELOG.md](CHANGELOG.md).

Contributing
------------

Please read carefully [CONTRIBUTING.md](CONTRIBUTING.md) before making a merge
request.

License and Author
------------------

- Author:: Samuel Bernard (<samuel.bernard@s4m.io>)
- Author:: Florian Philippon (<florian.philippon@s4m.io>)

```text
Copyright (c) 2016 Sam4Mobile

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
[cluster-search]: https://supermarket.chef.io/cookbooks/cluster-search
