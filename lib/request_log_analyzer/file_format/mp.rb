module RequestLogAnalyzer::FileFormat

  # **** info	Tue Mar 06 14:58:40 EST 2012	1331063920802	/dowjones/webservice/client/delegates/ics/ICSSubscriptionServiceClient	ICSSubscriptionServiceClient.getSubscription for uuid:bcd5c54e-7a0d-497d-bed9-54c9cb7e1e44:: Total execution time in milliseconds is: 134
  class Mp < Base
    
    extend CommonRegularExpressions

    line_definition :access do |line|
      line.header = true
      line.footer = true
      line.regexp = /(#{timestamp('%a %b %d %H:%M:%S %Z %Y')})\t\d+\t([\w|\/|.|\s]+)\s\w+\s\w+:[\w|\-|.]+::[\s|\w]+:\s(\d+)/
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
        #"#{value[0,4]}#{value[5,2]}#{value[8,2]}#{value[11,2]}#{value[14,2]}#{value[17,2]}".to_i
        t = DateTime.parse(value).strftime('%Y%m%d%H%M%S').to_i
      end
    end
    

  end
  
end
