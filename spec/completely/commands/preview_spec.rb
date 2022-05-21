require 'spec_helper'

describe Commands::Preview do
  subject { CLI.runner }
  before { system "cp lib/completely/templates/sample.yaml completely.yaml" }
  after  { system "rm -f completely.yaml" }

  context "with --help" do
    it "shows long usage" do
      expect{ subject.run %w[preview --help] }.to output_approval('cli/preview/help')
    end
  end

  context "without arguments" do
    it "outputs the generated script to STDOUT" do
      expect { subject.run %w[preview] }
        .to output_approval('cli/generated-script')
    end
  end

  context "with CONFIG_PATH" do
    it "outputs the generated script to STDOUT" do
      expect { subject.run %w[preview completely.yaml] }
        .to output_approval('cli/generated-script')
    end
  end

  context "with COMPLETELY_CONFIG_PATH env var" do
    before do
      reset_tmp_dir
      system "cp lib/completely/templates/sample.yaml spec/tmp/hello.yml"
      system "rm -f completely.yaml"
      ENV['COMPLETELY_CONFIG_PATH'] = 'spec/tmp/hello.yml'
    end

    after { ENV['COMPLETELY_CONFIG_PATH'] = nil }

    it "outputs the generated script to STDOUT" do
      expect { subject.run %w[preview] }
        .to output_approval('cli/generated-script')
    end
  end

  context "with an invalid configuration" do
    it "outputs a warning to STDERR" do
      expect { subject.run %w[preview spec/fixtures/broken.yaml] }
        .to output_approval('cli/warning').to_stderr
    end
  end

end
