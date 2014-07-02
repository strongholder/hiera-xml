class Hiera
  module Backend
    class Xml_backend

      def initialize
        require 'nokogiri'
        require 'active_support/core_ext/hash'

        @config = Config[:xml]

        @data_sources = Array.new
        if @config[:data_source].is_a?(Array) then
            @data_sources = @config[:data_source].map { |x| Nokogiri::XML(File.open(x)).remove_namespaces!}
        elsif @config[:data_source].is_a?(String) then
             @data_sources = [Nokogiri::XML(File.open(@config[:data_source])).remove_namespaces!]
        end
      end

      def extract_xpath(selector, doc)
          begin
            elements = Hash.from_xml(doc.xpath(selector).to_s)
            if elements then
              return elements.first[1]
            end
          rescue
            return nil
          end
      end

      def lookup(key, scope, order_override, resolution_type)
        require 'deep_merge'
        answer = nil

        paths = @config[:paths].map { |p| Backend.parse_string(p, scope, { 'key' => key }) }
        paths.insert(0, order_override) if order_override
        paths.each do |path|
          @data_sources.each do |xml_doc|
            elements = xml_doc.xpath(path)

            if elements.length > 0 then
              begin
                new_answer = Hash.from_xml(elements.to_s).first[1][key]

                if (new_answer == nil) and (answer == nil) then
                  answer = extract_xpath(key, xml_doc)
                  if answer then
                    return answer
                  end
                else
                  if answer == nil then
                    answer = {}
                  end

                  answer = new_answer.deep_merge(answer)

                end

              rescue
                  if answer == nil then
                      answer = self.extract_xpath(key, xml_doc)
                      if answer then
                        return answer
                      end
                  end
              end

            else
              if answer == nil then
                  answer = self.extract_xpath(key, xml_doc)
                  if answer then
                    return answer
                  end
              end
            end
          end
        end
        return answer
      end
    end
  end
end


