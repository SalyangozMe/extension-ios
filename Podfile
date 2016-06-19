platform :ios, '9.0'
use_frameworks!

def shared_pods
  pod 'Alamofire'
  pod 'AlamofireImage', '~> 2.0'
  pod 'TimeAgoInWords'
  pod 'AlamofireObjectMapper', '~> 3.0'
  pod 'KeychainAccess', :git => 'https://github.com/kishikawakatsumi/KeychainAccess.git'
end

target 'Salyangoz' do
  shared_pods
  pod 'Fabric'
  pod 'TwitterKit'
  pod 'TwitterCore'
end

target 'SalyangozKit' do
  shared_pods
end
