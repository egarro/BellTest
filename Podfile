# Uncomment the next line to define a global platform for your project

platform :ios, '11.0'
inhibit_all_warnings!
use_frameworks!

def import_pods
  pod 'GoogleAPIClientForREST/YouTube', '~> 1.2.1'
  pod 'GoogleSignIn', '~> 5.0'
  pod "youtube-ios-player-helper"
end

# Pods for BellTest
target 'BellTest' do
  import_pods

  target 'BellTestTests' do
    inherit! :complete
  end
end
