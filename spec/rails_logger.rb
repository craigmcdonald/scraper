#The puffing-billy gem logs to STDOUT unless Rails is partly defined.
#This fakes the necessary classes/methods and provides proper logging.
unless defined?(Rails)
  class Rails
    def self.logger
      @logger ||= Logger.new("#{__dir__.gsub('spec','log/')}test.log", 10, 1024000)
    end
    class Railtie
      def self.railtie_name(_);end
      def self.rake_tasks(&block);end
    end
  end
end
