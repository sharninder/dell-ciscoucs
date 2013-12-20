include ciscoucs

transport { 'ciscoucs':
  username => 'admin',
  password => 'admin',
  server   => '192.168.247.132',
}

ciscoucs_serviceprofile_clone { 'inservername':
   clonename => 'clone', 
   ensure    => present,
   transport  => Transport['ciscoucs'],
   source      => 'testing',
   target => 'test',
}
