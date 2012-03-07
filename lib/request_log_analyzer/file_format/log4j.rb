module RequestLogAnalyzer::FileFormat

  # FileFormat for log4j access logs.
#INFO: 2012-03-04	20:21:55	10.240.89.245	-	-	4515	GET	/v1/ent/roles/getregistrationdetails	uuid=c18ec396-6c93-479f-8b79-fef087c16f87&mg=com-wsj	200	355	-	387	http://commerce.wsj.com	Jakarta Commons-HttpClient/3.1	-
#INFO: 2012-03-04	20:21:56	10.240.89.245	-	-	4515	GET	/v1/ent/roles/check	-	200	173	-	1	http://10.240.91.27	-	-
#INFO: 2012-03-04	20:21:59	10.240.89.245	-	-	4515	GET	/v1/ent/roles/getregistrationdetails	uuid=&mg=com-wsj	412	207	-	3	http://commerce.wsj.com	Jakarta Commons-HttpClient/3.1	-
#INFO: 2012-03-04	20:22:01	10.240.89.245	-	-	4515	GET	/v1/ent/roles/check	-	200	173	-	0	http://10.240.91.27	-	-

  class Log4j < Base
    
    extend CommonRegularExpressions

    line_definition :access do |line|
      line.header = true
      line.footer = true
      line.regexp = /^INFO:\s(#{timestamp('%Y-%m-%d	%H:%M:%S')})\t(#{ip_address})\s\-\t\-\t(\d+)\t(\w+)\t([\w|\/|.]+)/
      line.capture(:timestamp).as(:timestamp)
      line.capture(:remote_ip)
      line.capture(:port).as(:integer)
      line.capture(:method)
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
