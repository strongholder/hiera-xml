class Hiera
  module Backend
    class Xml_backend

      def initialize
        require 'nokogiri'
        require 'active_support/core_ext/hash'

        @config = Config[:xml]
        @xml = Nokogiri::XML(File.open(@config[:file]))
        
      end

      def lookup(key, scope, order_override, resolution_type)
        answer = nil

        paths = @config[:paths].map { |p| Backend.parse_string(p, scope, { 'key' => key }) }
        paths.insert(0, order_override) if order_override
        paths.each do |path|

          elements = @xml.xpath(path)

          if elements.length > 0 then
            begin
              answer = Hash.from_xml(elements.to_s).first[1][key]

              if answer == nil then
                answer = Hash.from_xml(@xml.xpath(key).to_s).first[1]
                if answer then
                  return answer
                end
              end
              
            rescue 
            end
          end
        end

        answer
      end
    end
  end
end

