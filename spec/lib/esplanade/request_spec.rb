require 'spec_helper'

RSpec.describe Esplanade::Request do
  subject { described_class.new(env, tomogram) }

  let(:env) { {} }
  let(:tomogram) { double }

  describe '#method' do
    let(:method) { double }
    let(:env) { { 'REQUEST_METHOD' => method } }

    it { expect(subject.method).to eq(method) }
  end

  describe '#path' do
    let(:path) { double }
    let(:env) { { 'PATH_INFO' => path } }

    it { expect(subject.path).to eq(path) }
  end

  describe '#body' do
    let(:body) { double }

    before { allow(Esplanade::Request::Body).to receive(:craft).and_return(body) }

    it { expect(subject.body).to eq(body) }
  end

  describe '#request_tomogram' do
    let(:request_tomogram) { double }
    let(:tomogram) { double(find_request: request_tomogram) }

    it { expect(subject.request_tomogram).to eq(request_tomogram) }
  end

  describe '#json_schema' do
    let(:json_schema) { double }

    before { allow(subject).to receive(:request_tomogram).and_return(double(request: json_schema)) }

    it { expect(subject.json_schema).to eq(json_schema) }
  end

  describe '#error' do
    let(:error) { double }
    let(:tomogram) { double(find_request: double(request: nil)) }

    before do
      allow(Esplanade::Request::Body).to receive(:craft)
      allow(JSON::Validator).to receive(:fully_validate).and_return(error)
    end

    it { expect(subject.error).to eq(error) }
  end

  describe '#documented?' do
    let(:tomogram) { double(find_request: nil) }

    it { expect(subject.documented?).to be_falsey }
  end

  describe '#valid??' do
    let(:error) { double }
    let(:tomogram) { double(find_request: double(request: nil)) }

    before do
      allow(Esplanade::Request::Body).to receive(:craft)
      allow(JSON::Validator).to receive(:fully_validate).and_return(error)
    end

    it { expect(subject.valid?).to be_falsey }
  end
end
