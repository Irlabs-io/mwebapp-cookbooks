Cluster Search
==============

Description
-----------

Cluster Search (cluster-search) is a simple cookbook library which simplify
the search of members of a cluster. It relies on Chef search with a size guard
(to avoid inconsistencies during initial convergence) and allows a fall-back
to hostname listing if user does not want to rely on searches (because of
chef-solo for example).

Requirements
------------

None. Should work on any platform.

Usage
-----

First, call `::Chef::Recipe.send(:include, ClusterSearch)` to be able to use
`cluster_search` in your recipe.

Then method `cluster_search` take one argument, a hash which could contain:

- `role` and `size` to use search. Ex: `{ role: my_search, size: 2 }`
- or `hosts` to use a static list. Ex: `{ hosts: [ some_node ] }`

If both are defined, `hosts` is used.

It returns the list of the members of a cluster `hosts` and current node ID
`my_id` for this cluster (or -1 it is not a member).

For search, we suppose that all members of a cluster have a common role in
their run-list. For instance, all zookeeper nodes of a dedicated cluster for
kafka could use role *zookeeper-kafka*. By defining `role` to
*zookeeper-kafka* and configuring `size` to the expected size of the cluster,
we can find all the cluster members.

We can find input/output examples (used for test cases) in file
*.kitchen.yml*.

Libraries
---------

### default

Implements `cluster_search` method.

Recipes
-------

### default

Recipe used for testing.

Changelog
---------

Available in [CHANGELOG](CHANGELOG).

Contributing
------------

Please read carefully [CONTRIBUTING.md](CONTRIBUTING.md) before making a merge
request.

License and Author
------------------

- Author:: Samuel Bernard (<samuel.bernard@s4m.io>)

```text
Copyright (c) 2015-2016 Sam4Mobile

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
