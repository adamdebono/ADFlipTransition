Pod::Spec.new do |s|
	s.name = 'ADFlipTransition'
	s.version = '0.9.1'
	s.license = 'MIT'
	s.summary = 'An alternative presentation animation for iOS'
	s.authors = {
		'Adam Debono' => 'adam@adebono.com'
	}
	s.source = {
		:git => 'https://github.com/adamdebono/ADFlipTransition.git'
		:tag => '0.9.1'
	}
	s.source_files = 'ADFlipTransition'
	
	s.requires_arc = true
	s.ios.deployment_target = '5.0'
end