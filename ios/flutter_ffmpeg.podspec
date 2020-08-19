Pod::Spec.new do |s|
  s.name             = 'flutter_ffmpeg'
  s.version          = '0.2.10'
  s.summary          = 'FFmpeg plugin for Flutter.'
  s.description      = 'FFmpeg plugin based on mobile-ffmpeg for Flutter.'
  s.homepage         = 'https://github.com/tanersener/flutter-ffmpeg'

  s.author           = { 'Taner Sener' => 'tanersener@gmail.com' }
  s.license          = { :file => '../LICENSE' }

  s.requires_arc     = true
  s.ios.deployment_target = '9.3'
  s.static_framework = true

  s.source              = { :path => '.' }
  s.source_files        = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'

  s.default_subspec   = 'https'

  s.dependency          'Flutter'

  s.subspec 'min' do |ss|
    ss.source_files        = 'Classes/**/*'
    ss.public_header_files = 'Classes/**/*.h'

    ss.dependency 'mobile-ffmpeg-min', '4.4'
  end

  s.subspec 'min-lts' do |ss|
    ss.source_files        = 'Classes/**/*'
    ss.public_header_files = 'Classes/**/*.h'

    ss.dependency 'mobile-ffmpeg-min', '4.4.LTS'
  end

  s.subspec 'min-gpl' do |ss|
    ss.source_files        = 'Classes/**/*'
    ss.public_header_files = 'Classes/**/*.h'

    ss.dependency 'mobile-ffmpeg-min-gpl', '4.4'
  end

  s.subspec 'min-gpl-lts' do |ss|
    ss.source_files        = 'Classes/**/*'
    ss.public_header_files = 'Classes/**/*.h'

    ss.dependency 'mobile-ffmpeg-min-gpl', '4.4.LTS'
  end

  s.subspec 'https' do |ss|
    ss.source_files        = 'Classes/**/*'
    ss.public_header_files = 'Classes/**/*.h'

    ss.dependency 'mobile-ffmpeg-https', '4.4'
  end

  s.subspec 'https-lts' do |ss|
    ss.source_files        = 'Classes/**/*'
    ss.public_header_files = 'Classes/**/*.h'

    ss.dependency 'mobile-ffmpeg-https', '4.4.LTS'
  end

  s.subspec 'https-gpl' do |ss|
    ss.source_files        = 'Classes/**/*'
    ss.public_header_files = 'Classes/**/*.h'

    ss.dependency 'mobile-ffmpeg-https-gpl', '4.4'
  end

  s.subspec 'https-gpl-lts' do |ss|
    ss.source_files        = 'Classes/**/*'
    ss.public_header_files = 'Classes/**/*.h'

    ss.dependency 'mobile-ffmpeg-https-gpl', '4.4.LTS'
  end

  s.subspec 'audio' do |ss|
    ss.source_files        = 'Classes/**/*'
    ss.public_header_files = 'Classes/**/*.h'

    ss.dependency 'mobile-ffmpeg-audio', '4.4'
  end

  s.subspec 'audio-lts' do |ss|
    ss.source_files        = 'Classes/**/*'
    ss.public_header_files = 'Classes/**/*.h'

    ss.dependency 'mobile-ffmpeg-audio', '4.4.LTS'
  end

  s.subspec 'video' do |ss|
    ss.source_files        = 'Classes/**/*'
    ss.public_header_files = 'Classes/**/*.h'

    ss.dependency 'mobile-ffmpeg-video', '4.4'
  end

  s.subspec 'video-lts' do |ss|
    ss.source_files        = 'Classes/**/*'
    ss.public_header_files = 'Classes/**/*.h'

    ss.dependency 'mobile-ffmpeg-video', '4.4.LTS'
  end

  s.subspec 'full' do |ss|
    ss.source_files        = 'Classes/**/*'
    ss.public_header_files = 'Classes/**/*.h'

    ss.dependency 'mobile-ffmpeg-full', '4.4'
  end

  s.subspec 'full-lts' do |ss|
    ss.source_files        = 'Classes/**/*'
    ss.public_header_files = 'Classes/**/*.h'

    ss.dependency 'mobile-ffmpeg-full', '4.4.LTS'
  end

  s.subspec 'full-gpl' do |ss|
    ss.source_files        = 'Classes/**/*'
    ss.public_header_files = 'Classes/**/*.h'

    ss.dependency 'mobile-ffmpeg-full-gpl', '4.4'
  end

  s.subspec 'full-gpl-lts' do |ss|
    ss.source_files        = 'Classes/**/*'
    ss.public_header_files = 'Classes/**/*.h'

    ss.dependency 'mobile-ffmpeg-full-gpl', '4.4.LTS'
  end

end
