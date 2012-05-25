$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'

require 'rubygems'
require 'motion-cocoapods'
require 'bubble-wrap'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'iTrakt'
  app.icons = ['icon.png','icon@2x.png']

  app.pods do
    dependency 'KSCrypto'
    dependency 'NSData+Base64'
  end
end
