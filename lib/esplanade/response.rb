require 'json-schema'
require 'esplanade/response/body'

module Esplanade
  class Response
    attr_reader :status

    def initialize(status, raw_body, request)
      @status = status
      @raw_body = raw_body
      @request = request
    end

    def body
      @body ||= Esplanade::Response::Body.craft(@raw_body)
    end

    def response_tomograms
      @schemas ||= request.request_tomogram.find_responses(status: @status)
    end

    def json_schemas
      @json_schema ||= response_tomograms.map{ |action| action['body'] }
    end

    def error
      return JSON::Validator.fully_validate(json_schemas.first, body) if json_schemas.size == 1

      json_schemas.each do |json_schema|
        res = JSON::Validator.fully_validate(json_schema, body)
        return res if res == []
      end

      ['invalid']
    end

    def documented?
      @documented ||= !response_tomograms.nil?
    end

    def valid?
      @valid ||= error == []
    end
  end
end
