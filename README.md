# vagrant-docker-nsenter

This plugin allows you to use the `nsenter` command from your host (or from
your proxy VM if you are on Windows or Mac OS X) to run commands in your
Vagrant-provisioned Docker containers.

You can run non-interactive commands on all your containers or an interactive
command on a single container. The command defaults to an interactive
invocation of `/bin/bash` so that you get a shell in the container.

## Considerations

The default boot2docker proxy VM does not come with nsenter. There
[an issue open for its inclusion in the boot2docker project](https://github.com/boot2docker/boot2docker/issues/374).

Therefore, at this time, this plugin may only be useful when running a custom
proxy VM using [the vagrant_vagrantfile or vagrant_machine options](https://docs.vagrantup.com/v2/docker/configuration.html)
to the Docker provider.

## Getting started

To get started, you need to have Vagrant 1.6+ installed on your host machine.
To install the plugin, use the following command.

```bash
vagrant plugin install vagrant-docker-nsenter
```

## Working with this plugin

The syntax for this command is similar to `vagrant docker-run` in that you
must put the commands you wish to run after an `--`.

The command will default to running interactively, but you may also specify
`--no-interactive` to run commands non-interactively.

Output of non-interactive commands defaults to being prefixed with the
container name. This can be disabled with the `--no-prefix` flag.

Given three containers called `web`, `php`, and `mysql` you can run a single
non-interactive command on all hosts.

```bash
$ vagrant docker-nsenter --no-interactive -- hostname
==> mysql: 6223741bc113
==> php: 71dca3d53a0f
==> web: fe1d05768d5b
```

Or if you did not want prefixed output, add `--no-prefix`.

```bash
$ vagrant docker-nsenter --no-interactive --no-prefix -- hostname
6223741bc113
71dca3d53a0f
fe1d05768d5b
```

Finally, if you wanted to get an interactive shell, you can just invoke
`vagrant docker-nsenter` with the machine name. This will default to running
`/bin/bash`.

```bash
$ vagrant docker-nsenter mysql
root@6223741bc113:/#
```

## Author

Steven Merrill (@stevenmerrill) wrote this for use at @phase2.
