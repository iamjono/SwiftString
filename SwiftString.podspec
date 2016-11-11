Pod::Spec.new do |s|
  s.name = 'SwiftString'
  s.version = '1.0.10'
  s.license = 'MIT'
  s.summary = 'A comprehensive, lightweight string extension for Swift'
  s.homepage = 'http://jono.guthrie.net.nz'
  s.authors = { 'Radek Pietruszewski' => 'jono@guthrie.net.nz' }
  s.source = { :git => 'https://github.com/amayne/SwiftString.git', :tag => s.version }
  
  s.requires_arc = true
  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.source_files = 'Sources/*.swift'
end
