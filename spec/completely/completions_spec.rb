require 'spec_helper'

describe Completions do
  subject { described_class.load path }
  let(:path) { "spec/fixtures/#{file}.yaml" }
  let(:file) { "basic" }

  describe '#script' do
    it "returns a bash completions script" do
      expect(subject.script).to match_approval "completions/script"
    end

    context "with a configuration file that only includes patterns with spaces" do
      let(:file) { "only-spaces" }

      it "uses the first word of the first command as the function name" do
        expect(subject.script).to match_approval "completions/script-only-spaces"
      end
    end
  end

  describe '#wrapper_function' do
    it "returns the script wrapped inside a function" do
      expect(subject.wrapper_function).to match_approval "completions/function"
    end
  end
end
