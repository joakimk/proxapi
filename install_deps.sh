#!/bin/sh
apt-get update
apt-get install ruby
wget http://rubyforge.org/frs/download.php/70696/rubygems-1.3.7.tgz
tar xvfz rubygems-1.3.7.tgz
cd rubygems-1.3.7
ruby setup.rb
gem install sinatra daemons
cd ..
rm -rf rubygems-1.3.7*