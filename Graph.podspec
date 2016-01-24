Pod::Spec.new do |s|
    s.name = 'Graph'
    s.version = '1.0.1'
    s.license = 'BSD'
    s.summary = 'Elegant CoreData in Swift.'
    s.homepage = 'http://cosmicmind.io'
    s.social_media_url = 'https://www.facebook.com/graphkit'
    s.authors = { 'CosmicMind, Inc.' => 'support@cosmicmind.io' }
    s.source = { :git => 'https://github.com/CosmicMind/Graph.git', :tag => s.version }
    s.ios.deployment_target = '8.0'
    s.osx.deployment_target = '10.9'
    s.source_files = 'Sources/*.swift'
    s.requires_arc = true
end
