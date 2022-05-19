require 'spec_helper'

describe Commands::Test do
  subject { CLI.runner }

  before do
    system "cp lib/completely/sample.yaml completely.yaml"
    ENV['COMPLETELY_CONFIG_PATH'] = nil
    ENV['COMPLETELY_SCRIPT_PATH'] = nil
    ENV['COMPLETELY_SCRIPT_FUNCTION'] = nil
  end

  after  { system "rm -f completely.yaml" }

  context "with --help" do
    it "shows long usage" do
      expect{ subject.run %w[test --help] }.to output_approval('cli/test/help')
    end
  end

  context "without arguments" do
    it "shows a short usage" do
      expect { subject.run %w[test] }
        .to output_approval('cli/test/usage')
    end
  end

  context "with COMPLINE" do
    it "prints completions" do
      expect { subject.run ["test", "mygit --"] }
        .to output_approval('cli/test/comps-default')
    end
  end

  context "when COMPLETELY_CONFIG_PATH is set" do
    before do
      reset_tmp_dir
      File.write "spec/tmp/in.yaml", { "play" => ["command", "conquer"] }.to_yaml
      ENV['COMPLETELY_CONFIG_PATH'] = "spec/tmp/in.yaml"
    end

    it "tests against this completely file" do
      expect { subject.run ["test", "play co"] }
        .to output_approval('cli/test/comps-custom-config')
    end
  end

  context "when COMPLETELY_SCRIPT_PATH and COMPLETELY_SCRIPT_FUNCTION are set" do
    before do
      ENV['COMPLETELY_SCRIPT_PATH'] = "/usr/share/bash-completion/completions/apt"
      ENV['COMPLETELY_SCRIPT_FUNCTION'] = "_apt"
    end

    it "tests against this script" do
      expect { subject.run ["test", "apt up"] }
        .to output_approval('cli/test/comps-apt')
    end
  end

  context "when there is no compeltely.yaml or any environment instructions" do
    before { system "rm -f completely.yaml" }
    
    it "fails gracefully" do
      expect { subject.run ["test", "mygit --"] }
        .to raise_approval('cli/test/error')
    end
  end

end
