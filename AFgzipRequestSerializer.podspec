Pod::Spec.new do |s|
  s.name         = "AFgzipRequestSerializer"
  s.version      = "0.0.2"
  s.summary      = "gzip Request Serializer for AFNetworking"
  s.homepage     = "https://github.com/AFNetworking/AFgzipRequestSerializer"
  s.social_media_url = 'https://twitter.com/AFNetworking'
  s.license      = 'MIT'
  s.author       = { "Mattt Thompson" => "m@mattt.me" }
  s.source       = { :git => "https://github.com/AFNetworking/AFgzipRequestSerializer.git",
                     :tag => "0.0.2" }

  s.source_files = 'AFgzipRequestSerializer'
  s.requires_arc = true

  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'

  s.dependency 'AFNetworking', '~> 2.0'
  s.dependency 'Godzippa', '~> 1.0'
end
