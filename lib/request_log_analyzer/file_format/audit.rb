module RequestLogAnalyzer::FileFormat

  #2012-03-05 14:23:45,932 INFO  AnonymousIoService-11 djcs.audit.listener.AuditHandler  - [/10.240.91.2:40813] RECEIVED: 	<audit handler='AUTH' method='LOGIN'>
  class Audit < Base
    
    extend CommonRegularExpressions

    line_definition :access do |line|
      line.header = true
      line.footer = true
      line.regexp = /^(#{timestamp('%Y-%m-%d %H:%M:%S')}),\d+\s\w+\s\s\w+\-\w+\s([\w|\.]+)/
      line.capture(:timestamp).as(:timestamp)
      line.capture(:path).as(:path)
    end

    report do |analyze|
      analyze.timespan
      analyze.hourly_spread

      analyze.frequency :category => :path, :title => "Most popular URIs"

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
