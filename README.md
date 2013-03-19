Rails 4 on Vagrant
==========

This Vagrant includes:

* Ubuntu 12.04
* Postgres 9.1
* Rails 4.0.0 pre


Instructions
==========

Virtual Machine
----------
Ensure you have [Oracle
VirtualBox](http://www.oracle.com/technetwork/server-storage/virtualbox/downloads/index.html) installed (Vagrant also supports
VMWare and Amazon AWS with additional configuration).  

Ensure that you have the vagrant gem installed on your system or host
environment.

Vagrant
----------
rbenv/rvm
```bash
gem install vagrant
```

system ruby
```bash
sudo gem install vagrant
```

Your Rails App
----------

You have a couple options here.  With and existing Rails app, you can move an existing Rails
application into the app/ folder. 

For a new Rais 4 app you'll want to get right to it.  First check the
'manifests/base.pp' puppet file and update the Postgres database name to
match your future app name.

Next, start the vagrant virtual machine (You'll see some errors, I still
assume the rails app is running when I start the VM).  Once you get the
command prompt back ssh into the vagrant vm and create your app.

```bash
vagrant up
vagrant ssh
```

inside the vagrant
```bash
cd /vagrant
rails new MY_APP
mv MY_APP app
```


[http://localhost:8980] will forward to port 3000 on the vagrant box.


