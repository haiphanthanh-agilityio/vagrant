#
# Cookbook Name:: postgresql-locale-fix
# Recipe:: default
#
# Copyright 2014 (c) hai.phanthanh@asnet.com.vn
#

ENV['LANGUAGE'] = ENV['LANG'] = ENV['LC_ALL'] = "en_US.UTF-8"
