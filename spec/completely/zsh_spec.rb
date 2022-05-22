require 'spec_helper'

describe "zsh compatibility" do
  let(:completions) { Completely::Completions.load 'spec/fixtures/basic.yaml' }
  let(:words) { "completely generate " }
  let(:tester_script) { completions.tester.tester_script words }
  let(:shell) { 'zsh' }

  before do
    reset_tmp_dir
    system "mkdir -p spec/tmp/somedir"
    File.write "spec/tmp/test.sh", tester_script
  end

  subject do
    `docker run --rm -it -v $PWD/spec/tmp:/app dannyben/zsh #{shell} /app/test.sh`.strip
  end

  describe "completions script and test script" do
    it "returns completions without erroring" do
      expect(subject).to eq "somedir --help --force"
    end

    context "on bash" do
      let(:shell) { 'bash' }
      
      it "returns the same output" do
        expect(subject).to eq "somedir --help --force"
      end
    end
  end

end