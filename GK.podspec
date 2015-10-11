Pod::Spec.new do |s|
    s.name = 'GK'
    s.version = '3.20.1'
    s.license = { :type => 'AGPLv3+', :file => 'LICENSE' }
    s.summary = 'A Powerful Data-Driven Framework In Swift'
    s.homepage = 'http://www.graphkit.io/'
    s.social_media_url = 'https://www.facebook.com/graphkit'
    s.authors = { 'GraphKit Inc.' => 'support@graphkit.io' }
    s.source = { :git => 'https://github.com/GraphKit/GraphKit.git', :tag => s.version }
    s.ios.deployment_target = '8.0'
    s.osx.deployment_target = '10.10'
    s.source_files = 'Source/*.swift'
    s.requires_arc = true
end
