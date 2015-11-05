# Copyright 2015 Hewlett-Packard Development Company, L.P.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# = Resource: zoidberg::instance
#
# Resource to set up a running instance of zoidberg.
#
# example usage:
#
#  include zoidberg
#  zoidberg::instance{ '/path/to/config/file.yaml': }
#
define zoidberg::instance (
  $ensure  = 'running',
  $suffix = $name,
  $logfile = '',
  $configfile = "/etc/zoidberg/${name}.conf",
  $subscribe = [],
) {

  if ($logfile != '') {
    $process_args = "-c $configfile --logfile $logfile"

    file { $logfile:
      ensure => present,
      owner  => 'zoidberg',
    }
  } else {
    $process_args = "-c $configfile"
  }

  file { "/etc/init.d/zoidberg-${suffix}":
    ensure  => present,
    mode    => '0555',
    content => template('zoidberg/zoidberg.init.erb'),
  }

  $_subscribe = flatten([$subscribe, File["/etc/init.d/zoidberg-${suffix}"]])

  service { "zoidberg-$suffix":
    ensure => $ensure,
    subscribe => $_subscribe,
  }
}
