# encoding: utf-8
require "spec_helper"

describe Her::Middleware::FirstLevelParseJSONJsonapi do
  subject { described_class.new }
  let(:body_without_errors) { "{\"id\": 1, \"name\": \"Tobias Fünke\", \"meta\": 3}" }
  let(:body_with_errors) { "{\"id\": 1, \"name\": \"Tobias Fünke\", \"errors\": { \"name\": [ \"not_valid\", \"should_be_present\" ] }, \"meta\": 3}" }
  let(:body_with_malformed_json) { "wut." }
  let(:body_with_invalid_json) { "true" }
  let(:nil_body) { nil }

  it "parses body as json" do
    subject.parse(body_without_errors, 200).tap do |json|
      json[:data].should == { :id => 1, :name => "Tobias Fünke" }
      json[:metadata].should == 3
    end
  end

  it "parses :body key as json in the env hash" do
    env = { :body => body_without_errors }
    subject.on_complete(env)
    env[:body].tap do |json|
      json[:data].should == { :id => 1, :name => "Tobias Fünke" }
      json[:metadata].should == 3
    end
  end

  it 'ensures the errors are a hash if there are no errors' do
    subject.parse(body_without_errors, 200)[:errors].should eq({})
  end

  it 'ensures the errors are a hash if there are no errors' do
    subject.parse(body_with_errors, 202)[:errors].should eq({:name => [ 'not_valid', 'should_be_present']})
  end

  it 'ensures that malformed JSON throws an exception' do
    expect { subject.parse(body_with_malformed_json, 200) }.to raise_error(Her::Errors::ParseError, 'Response from the API must behave like a Hash or an Array (last JSON response was "wut.")')
  end

  it 'ensures that invalid JSON throws an exception' do
    expect { subject.parse(body_with_invalid_json, 200) }.to raise_error(Her::Errors::ParseError, 'Response from the API must behave like a Hash or an Array (last JSON response was "true")')
  end

  it 'ensures that a nil response returns an empty hash' do
    subject.parse(nil_body, 200)[:data].should eq({})
  end

  context 'with status code 204' do
    it 'returns an empty body' do
      env = { :status => 204 }
      subject.on_complete(env)
      env[:body].tap do |json|
        json[:data].should == { }
      end
    end
  end
end
