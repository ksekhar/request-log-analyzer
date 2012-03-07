module RequestLogAnalyzer::FileFormat

#2012-03-05 23:59:47,13310099855820.528756516708793,205ca974-0863-4a4a-a472-6e269e4db6cf,jedwardrogers,GetSubscriptionResponse com.dowjones.selfservice.service.consumer.ics.stub.SubscriptionServiceServiceStub.getSubscription(GetSubscriptionRequest),353

  class Ss < Base
    
    extend CommonRegularExpressions

    line_definition :access do |line|
      line.header = true
      line.footer = true
      line.regexp = /^(#{timestamp('%Y-%m-%d %H:%M:%S')}),\d+\.\d+,[\w|\-]+,\w+,\w+\s([\w|\.|\(|\)]+),(\d+)/
      line.capture(:timestamp).as(:timestamp)
      line.capture(:path).as(:path)
      line.capture(:duration).as(:duration, :unit => :msec)
    end

    report do |analyze|
      analyze.timespan
      analyze.hourly_spread

      analyze.frequency :category => :path, :title => "Most popular URIs"

      analyze.duration :duration => :duration,  :category => :path, :title => 'Request duration'
    end
    
    class Request < RequestLogAnalyzer::Request
      # Do not use DateTime.parse, but parse the timestamp ourselves to return a integer
      # to speed up parsing.
      def convert_timestamp(value, definition)
        "#{value[0,4]}#{value[5,2]}#{value[8,2]}#{value[11,2]}#{value[14,2]}#{value[17,2]}".to_i
      end
    end
    

  end
  
end
