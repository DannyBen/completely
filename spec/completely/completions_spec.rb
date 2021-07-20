require 'spec_helper'

describe Completions do
  subject { described_class.load path }
  let(:path) { "spec/fixtures/#{file}.yml" }
  let(:file) { "basic" }

  describe '#script' do
    it "returns a bash completions script" do
      expect(subject.script).to match_approval "completions/script"
    end
  end
end
