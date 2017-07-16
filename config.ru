# This file is used by Rack-based servers to start the application.
require ::File.expand_path('../config/environment',  __FILE__)
map '/csw' do
  if Rails.env.profile?
    # configure ruby-prof behavior when profiling the application and running with the profile environment
    # for visualizing csw-call-grind.out.app on a Mac install QCachegrind using brew or MacPorts
    # profiling data location and type
    use Rack::RubyProf, :path => Rails.root.join('log','rubyprof'),
    :printers => {::RubyProf::FlatPrinter => 'csw-flat.txt',
                  ::RubyProf::GraphPrinter => 'csw-graph.txt',
                  ::RubyProf::GraphHtmlPrinter => 'csw-graph.html',
                  ::RubyProf::CallStackPrinter => 'csw-call-stack.html',
                  ::RubyProf::CallTreePrinter => 'csw-call-grind.out.app'}
  end
  run Csw::Application
end

