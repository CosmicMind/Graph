Pod::Spec.new do |s|
    s.name = 'Graph'
    s.version = '2.2.2'
    s.swift_version = '4.0'
    s.license = 'BSD-3-Clause'
    s.summary = 'Graph is a semantic database that is used to create data-driven applications.'
    s.homepage = 'http://graphswift.io'
    s.social_media_url = 'https://www.facebook.com/cosmicmindcom'
    s.authors = { 'CosmicMind, Inc.' => 'support@cosmicmind.com' }
    s.source = { :git => 'https://github.com/CosmicMind/Graph.git', :tag => s.version }
    s.ios.deployment_target = '8.0'
    s.osx.deployment_target = '10.10'
    s.source_files = 'Sources/*.swift'
    s.requires_arc = true
end
