module RequestLogAnalyzer::FileFormat

  #Instrumentation Data :Mon, 05 Mar 2012 17:15:05 EST|WS:e81ce5e1-c198-4e3a-88cc-2d28019edc58|10.240.89.245|10.240.91.29|sbkcomappp09.wsjprod.dowjones.net|https://sbkics.omc.wsjprod.dowjones.net:4020/ics/ws/SubscriptionService/v1/soap/service/subscriptionServiceService|getSubscription|SUCCESS|118
  class Lego < Base
    
    extend CommonRegularExpressions

    line_definition :access do |line|
      line.header = true
      line.footer = true
      line.regexp = /\w+\s\w+ :(#{timestamp('%a, %d %b %Y %H:%M:%S %Z')})\|\w+:\w+\-\w+\-\w+\-\w+\-\w+\|\w+\.\w+\.\w+\.\w+\|\w+\.\w+\.\w+\.\w+\|\w+\.\w+\.\w+\.\w+\|[\w|\/|.]+:[\w|\/|.]+:\d+(\/\w+\/\w+\/\w+\/\w+\/\w+\/\w+\/\w+\|\w+)\|(\w+)\|(\d+)/
      line.capture(:timestamp).as(:timestamp)
      line.capture(:path).as(:path)
      line.capture(:status)
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
        #"#{value[12,4]}#{value[5,2]}#{value[8,2]}#{value[11,2]}#{value[14,2]}#{value[17,2]}".to_i
        t = DateTime.parse(value).strftime('%Y%m%d%H%M%S').to_i
      end
    end
    

  end
  
end
