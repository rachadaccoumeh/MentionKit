#
# Be sure to run `pod lib lint MentionKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
	s.name             = 'MentionKit'
	s.version          = '1.0.0'
	s.summary					 = 'MentionKit: A versatile and user-friendly iOS pod library for seamless user mentions'
	s.dependency 'SDWebImage'
	s.dependency 'GrowingTextView'
	# This description is used to generate tags and improve search results.
	#   * Think: What does it do? Why did you write it? What is the focus?
	#   * Try to keep it short, snappy and to the point.
	#   * Write the description between the DESC delimiters below.
	#   * Finally, don't worry about the indent, CocoaPods strips it!
	
	s.description      = <<-DESC
	MentionKit is a powerful and flexible pod library designed to simplify the process of implementing user mentions in iOS applications. With MentionKit, developers can effortlessly enable their users to mention other users by name, complete with customizable user avatars fetched from image URLs.

	This library provides a robust and interactive mention selection menu that dynamically tracks the cursor's location in the text input, making it easy for users to select and tag other individuals. Additionally, MentionKit allows users to control the height of the mention menu, ensuring a seamless user experience for any text input view.

	Key Features:
	- Easily integrate user mentions in your iOS app.
	- Automatic fetching of user avatars from image URLs Using SDWebImage.
	- Interactive mention selection menu with cursor tracking.
	- Customizable height to suit different text input views.
	- Flexibility to trigger mentions programmatically for custom user list views.
	- Support for clickable user mentions to enhance user engagement.

	MentionKit empowers iOS developers to implement an intuitive and engaging user mention system, enhancing social interactions within their applications. Whether you're building a messaging app, a social network, or any other platform that involves user interactions, MentionKit is the perfect companion to take your app's user experience to the next level.

	Give your users the ability to seamlessly mention their friends, colleagues, or connections with MentionKit, and make user interactions more dynamic and enjoyable than ever before.

	DESC
	
	s.homepage         = 'https://github.com/rachadaccoumeh/MentionKit'
	# s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
	s.license          = { :type => 'MIT', :file => 'LICENSE' }
	s.author           = { 'rachadaccoumeh' => 'rachacaccoumeh@gmail.com' }
	s.source           = { :git => 'https://github.com/rachadaccoumeh/MentionKit.git', :tag => s.version.to_s }
	# s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
	
	s.ios.deployment_target = '10.0'
	
	s.source_files = 'MentionKit/Classes/**/*'
	
	# s.resource_bundles = {
	#   'MentionKit' => ['MentionKit/Assets/*.png']
	# }
	
	# s.public_header_files = 'Pod/Classes/**/*.h'
	# s.frameworks = 'UIKit', 'MapKit'
	# s.dependency 'AFNetworking', '~> 2.3'
end
