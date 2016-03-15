class Hash

  def to_soap(options = {})
    require 'active_support/builder' unless defined?(Builder)

    options = options.dup
    options[:indent]       ||= 2
    options[:root]         ||= 'hash'
    options[:soap_builder] ||= Builder::XmlMarkup.new(indent: options[:indent])

    soap_builder = options[:soap_builder]

    soap_builder.Envelope xmlns: "http://schemas.xmlsoap.org/soap/envelope/" do

      soap_builder.Body do

        soap_builder.tag!(options[:operation], xmlns: options[:namespace]) do
          soap_builder.tag!(options[:base_element], "\n#{build_internal_xml(options)}")
        end

      end

    end
  end

  def build_internal_xml(options = {})
    options[:builder] ||= Builder::XmlMarkup.new(indent: options[:indent])
    builder = options[:builder]

    root = ActiveSupport::XmlMini.rename_key(options[:root].to_s, options)

    builder.tag!(root) do
      each { |key, value| ActiveSupport::XmlMini.to_tag(key, value, options) }
      yield builder if block_given?
    end

    builder.target!.gsub(" ", "")
  end

end
