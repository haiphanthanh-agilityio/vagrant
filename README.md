# Development Environment setup

### Pre-requirements:
- Ruby installed with Ruby gems (1.9 or later)
- Git
- On Windows OS, [Ruby Development Kit](http://rubyinstaller.org/downloads/) must be installed successful
  * Important notes for Windows OS, do not using: Ruby x64, Ruby Development Kit x64

### 1. Install VirtualBox
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

### 2. Install gems
<pre>
$ bundle install --path=vendor/bundler
</pre>

### 3. Install cookbooks
<pre>
$ bundle exec librarian-chef install
</pre>

### 4. Executing the vagrant command to build up env
  Please issue the following command:
  <pre>
    $ bundle exec vagrant up
  </pre>

More info to work with Vagrant, visit [documents](http://docs.vagrantup.com/v2/cli/index.html)

### 5. Open SSH connection
<pre>
$ bundle exec vagrant ssh
</pre>

### 6. Shutdown boxes
* Shutdown the box
  <pre>
  $ bundle exec vagrant halt
  </pre>

## Notes
* IPs of 'host': 192.168.13.1, 'ranun-dev': 192.168.13.2
* Working folders: 
    - /home/vagrant/app
    - /home/vagrant/design
* Database connection: 
    host: localhost
    user: postgres
    password: postgres
    encoding: utf8

## Known Issues
There is an issue relative to "bsdtar" when working with vagrant box, if the error occurred when downloading and extracting the vagrant box, pls install "bsdtar" depending on your working OS

## What's in the box
- RVM with Ruby 2.1.2
- NodeJs and NPM (included: Bower, Grunt)
- Postgresql
