require 'spec_helper'

describe Tester do
  subject { described_class.new script_path: script_path, function_name: function_name }
  let(:function_name) { '_cli_completions' }
  let(:script_path) { "spec/fixtures/tester/#{fixture}.bash" }
  let(:fixture) { 'default' }
  let(:compline) { "cli co" }

  before :all do
    # Create an up to date fixture
    comps = Completions.load "spec/fixtures/tester/default.yaml"
    File.write "spec/fixtures/tester/default.bash", comps.script
  end

  describe "#tester_script" do
    it "sources the script using its absolute path" do
      expect(subject.tester_script compline).to match %r[source "/.*spec/fixtures/tester/default.bash"]
    end

    it "returns a valid testing script" do
      expect(subject.tester_script compline).to match_approval("tester/script_path")
        .except(/source "(.*)"/, 'source "<path removed>"')
    end
  end

  describe '#test' do
    it "returns an array with completions" do
      expect(subject.test compline).to eq ["command", "conquer"]
    end
  end

  context "with script instead of script_path" do
    subject { described_class.new script: script, function_name: function_name }
    let(:script) { "# some completion script" }

    describe '#tester_script' do
      it "includes the embedded script" do
        expect(subject.tester_script compline).to match_approval("tester/script")
      end
    end
  end

end
