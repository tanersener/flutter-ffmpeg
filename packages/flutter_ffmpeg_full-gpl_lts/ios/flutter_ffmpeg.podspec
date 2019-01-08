Pod::Spec.new do |s|
  s.name             = 'flutter_ffmpeg'
  s.version          = '0.1.1'
  s.summary          = 'FFmpeg plugin for Flutter.'
  s.description      = 'FFmpeg plugin based on mobile-ffmpeg for Flutter.'
  s.homepage         = 'https://github.com/tanersener/flutter-ffmpeg'

  s.author           = { 'Taner Sener' => 'tanersener@gmail.com' }
  s.license          = { :file => '../LICENSE' }

  s.requires_arc     = true
  s.ios.deployment_target = '9.3'

  s.source              = { :path => '.' }
  s.source_files        = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'

  s.dependency          'Flutter'
  s.dependency          'mobile-ffmpeg-full-gpl', '4.2.LTS'

end

