# PHP 7 RC5 - Vagrant build

Shell provisioned Vagrant build for testing the PHP 7.0.0RC7 version.

- box available at 192.168.50.7
- Debian 7.5 x64 (Wheezy)
- PHP 7 RC7
- Apache 2.2.22


## Configure your shared folders

- open `Vagrantfile` and add your (host) shared folders (where your project is) and virtual machine paths
(around lne 52)

example:
```ruby
    config.vm.synced_folder "/home/apps/some-project", "/vagrant/deploy/public/some-project"
```

This app should be accessible at `http://192.168.50.7/some-project`


## Usage

- to start the machine run `vagrant up`
- on the first run you should `vagrant provision` to build the environment, so be patient
- to stop run `vagrant halt`


## Missing

- MySQL (because nothing stops you to connect to your host database, if any)


## Easy modify

Can be used as a base for testing other future releases. To create another environment,
find another version at https://downloads.php.net/~ab/

- open `provision_ini.sh` and change the desired PHP version (`PHP_RELEASE` variable)
- open `php/configure.sh` to modify the list of extensions/modules
- open `Vagrantfile` around line 21, change the name of the virtual machine name (for VirtualBox machine label)


## Useful links

- [The PHP releases](https://downloads.php.net/~ab/)
- [Vagrant](https://www.vagrantup.com)
- [VirtualBox](https://www.virtualbox.org)