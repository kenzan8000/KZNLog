Pod::Spec.new do |s|

  s.name         = "KZNLog"
  s.version      = "0.1"
  s.summary      = ""
  s.description  = <<-DESC
                   A longer description of KZNBlinkView in Markdown format.

                   * KZNLog is log macro like NSLog and log viewer in iOS application.
                   * KZNLog is tested on iOS 5.0+ and requires ARC.
                   DESC
  s.homepage     = "http://kenzan8000.org"
  s.license      = { :type => 'MIT' }
  s.author       = { "Kenzan Hase" => "kenzan8000@gmail.com" }
  s.platform     = :ios, '5.0'
  s.source       = { :git => "https://github.com/kenzan8000/KZNLog.git", :tag => "v0.1" }
  s.source_files = 'KZNLog/*.{h,m}'
  s.requires_arc = true
  # s.exclude_files = 'Classes/Exclude'
  # s.public_header_files = 'Classes/**/*.h'
end
