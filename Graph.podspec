Pod::Spec.new do |s|
    s.name = 'Graph'
    s.version = '1.2.1'
    s.license = 'BSD-3-Clause'
    s.summary = 'Graph is a data-driven framework for CoreData. It comes complete with iCloud support.'
    s.homepage = 'http://cosmicmind.io'
    s.social_media_url = 'https://www.facebook.com/graphkit'
    s.authors = { 'CosmicMind, Inc.' => 'support@cosmicmind.io' }
    s.source = { :git => 'https://github.com/CosmicMind/Graph.git', :tag => s.version }
    s.ios.deployment_target = '8.0'
    s.osx.deployment_target = '10.9'
    s.source_files = 'Sources/*.swift'
    s.requires_arc = true
end
