require 'spec_helper'

describe Her::Errors do

  describe Her::Errors::ResourceInvalid do

    describe '#new' do
      let(:resource) { double('resource', :status =>  '401', :response_errors => {}) }

      it 'should return the status of the response' do
        error = Her::Errors::ResourceInvalid.new(resource)
        expect(error.message).to match (/Status/)
      end

      it 'should run if the error message is not an array' do
        expect{ Her::Errors::ResourceInvalid.new(resource) }.to_not raise_error
      end

    end

  end

end