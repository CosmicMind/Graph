Pod::Spec.new do |s|
    s.name = 'GraphKit'
    s.version = '0.1.0'
    s.license = 'AGPLv3'
    s.summary = 'next generation graph framework for iOS'
    s.homepage = 'http://graphkit.io'
    s.authors = { 'Daniel Dahan' => 'daniel@graphkit.io' }
    s.social_media_url = 'https://www.facebook.com/graphkit'
    s.source = { :git => 'https://github.com/GraphKit/graphkit-ios.git', :tag => s.version }
    s.ios.deployment_target = '8.1'
    s.source_files = 'GraphKit/*.swift'
end
