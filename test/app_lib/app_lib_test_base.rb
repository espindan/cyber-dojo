
require_relative '../test_coverage'
require_relative '../all'
require_relative '../test_base'

$test_framework = nil
$output = nil

class AppLibTestBase < TestBase

  #intercept (wip) to be used to save output into folder based on language and
  #expected(colour) in a file named after the test being run

  def setup
    super
    set_runner_class_name('TestRunnerStub')
    set_languages_root('/var/www/cyber-dojo/languages/')
  end
  
  def teardown
    super
  end

#=begin
  def self.line_number(s)
    s.match(/^(.+?):(\d+)/)
    $2.to_i
  end
  
  def self.test(name, &block)
    @@info ||= {}
    @@info[line_number(caller[0])] = name
    define_method("test_#{name}".to_sym, &block)
  end

  def assert_equal(expected,actual)
    @colour = expected        
    num =  self.class.line_number(caller[0])
    smaller = @@info.keys.select{|n| n < num }
    largest = smaller.sort[-1]
    test_name = @@info[largest]
    dojo = Dojo.new
    filename = sanitized_filename(test_name)    
    filename.slice! "_is_red"
    filename.slice! "_is_amber"
    filename.slice! "_is_green"
    path = "/var/www/cyber-dojo/test/app_lib/test_output/#{$test_framework}/#{@colour}"
    `mkdir -p #{path}`
    dojo.disk[path].write(filename, $output)
  end
  
  class OutputParser
    def self.method_missing(cmd,*args)
      if !cmd.to_s.start_with? 'parse_'
        raise RuntimeError.new("#{cmd.to_s} did not start with parse_")
      end
      $test_framework = cmd.to_s['parse_'.length..-1]
      $output = args[0]
    end
  end
      
  def sanitized_filename(filename)
    # http://stackoverflow.com/questions/1939333/how-to-make-a-ruby-string-safe-for-a-filesystem
    # Split the name when finding a period which is preceded by some
    # character, and is followed by some character other than a period,
    # if there is no following period that is followed by something
    # other than a period (yeah, confusing, I know)
    fn = filename.split /(?<=.)\.(?=[^.])(?!.*\.[^.])/m

    # We now have one or two parts (depending on whether we could find
    # a suitable period). For each of these parts, replace any unwanted
    # sequence of characters with an underscore
    fn.map! { |s| s.gsub /[^a-z0-9\-]+/i, '_' }

    # Finally, join the parts with a period and return the result
    return fn.join '.'
  end
#=end
        
end
