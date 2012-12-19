require 'httparty'
require 'json'
require 'cgi'

class PearsonKitchenManager
  include HTTParty

  if ENV['RAILS_ENV'] == 'development'
    debug_output $stderr
  end

  format :plain
  default_timeout 30

  attr_accessor :api_key, :timeout

  def initialize(api_key = nil, extra_params = {})
    @api_key = api_key || ENV['PEARSON_API_KEY'] || self.class.api_key
    @default_params = {:apikey => @api_key}.merge(extra_params)
  end

  def api_key=(value)
    @api_key = value
    @default_params = @default_params.merge({:apikey => @api_key})
  end

  def get_exporter
    GibbonExport.new(@api_key, @default_params)
  end

  def base_api_url
    "http://api.pearson.com/kitchen-manager/v1/"
  end

protected
  def call(method, params = {})
    api_url = base_api_url + method

    if params.keys.include?(:url_extension)
      api_url << "/" << params.delete(:url_extension)
    end

    params = @default_params.merge(params)
    response = self.class.get(api_url, :query => params.collect{|k, v| normalize_param(k, v)}.join(), :timeout => @timeout)


    # Some calls (e.g. recipes) return json fragments
    # (e.g. true) so wrap in an array prior to parsing
    response = JSON.parse('['+response.body+']').first

    if response == "Access Denied"
      raise "Error from Pearson Kitchen Manager API: #{response}"
    end

    response
  end

  def normalize_param(key, value)
    param = ''
    stack = []

    if value.is_a?(Array)
      param << Hash[*(0...value.length).to_a.zip(value).flatten].map {|i,element| normalize_param("#{key}[#{i}]", element)}.join
    elsif value.is_a?(Hash)
      stack << [key,value]
    else
      param << "#{key}=#{URI.encode(value.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))}&"
    end

    stack.each do |parent, hash|
      hash.each do |key, value|
        if value.is_a?(Hash)
          stack << ["#{parent}[#{key}]", value]
        else
          param << normalize_param("#{parent}[#{key}]", value)
        end
      end
    end

    param
  end

  def method_missing(method, *args)
    method = method.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase } #Thanks for the gsub, Rails
    method = method[0].chr.downcase + method[1..-1].gsub(/aim$/i, 'AIM')
    call(method, *args)
  end

  class << self
    attr_accessor :api_key

    def method_missing(sym, *args, &block)
      new(self.api_key).send(sym, *args, &block)
    end
  end

end


module HTTParty
  module HashConversions
    # @param key<Object> The key for the param.
    # @param value<Object> The value for the param.
    #
    # @return <String> This key value pair as a param
    #
    # @example normalize_param(:name, "Bob Jones") #=> "name=Bob%20Jones&"
    def self.normalize_param(key, value)
      param = ''
      stack = []

      if value.is_a?(Array)
        param << Hash[*(0...value.length).to_a.zip(value).flatten].map {|i,element| normalize_param("#{key}[#{i}]", element)}.join
      elsif value.is_a?(Hash)
        stack << [key,value]
      else
        param << "#{key}=#{URI.encode(value.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))}&"
      end

      stack.each do |parent, hash|
        hash.each do |key, value|
          if value.is_a?(Hash)
            stack << ["#{parent}[#{key}]", value]
          else
            param << normalize_param("#{parent}[#{key}]", value)
          end
        end
      end

      param
    end
  end
end