platform :ios, '9.0'
use_frameworks!

def shared_pods
    pod 'Alamofire'
    pod 'AlamofireObjectMapper', '~> 3.0'
end

target 'Salyangoz' do

end

target 'SalyangozKit' do
    shared_pods
    pod 'KeychainAccess', 
         :git => 'https://github.com/kishikawakatsumi/KeychainAccess.git'
end