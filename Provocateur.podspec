Pod::Spec.new do |s|

  s.name         = "Provocateur"
  s.version      = "0.0.1"
  s.summary      = "A near-control variable configuration library."

  s.description  = <<-DESC
                Provocateur is a set of a classes which help you remotely configure variables in your app.
                By "remotely" we actually mean "closely", since it uses MultipeerConnectivity.framework
                to find and interact with Provocateur capable apps.
                   DESC

  s.homepage     = "http://github.com/pacifichelm/Provocateur"

  s.license      = { :type => 'BSD', :file => 'LICENSE' }

  s.author       = { "Patrick B. Gibson" => "patrick@fadeover.org" }

  s.platform     = :ios, '7.0'

  s.source       = { :git => "https://github.com/pacifichelm/Provocateur.git", :tag => '0.0.1' }

  s.source_files  = 'Provocateur', 'Provocateur/**/*.{h,m}'
  s.exclude_files = 'Classes/Exclude'

  # s.public_header_files = 'Classes/**/*.h'

  s.requires_arc = true
  
  s.dependency 'HexColors', '~> 2.2.1'

end
