require 'spec_helper'

describe "generated script" do
  subject { Completions.load "#{fixture}.yaml" }
  let(:fixture) { 'ftp' }
  let(:compline) { 'ftp ' }

  let(:response) do
    Dir.chdir 'spec/fixtures/integration' do
      subject.tester.test(compline).sort
    end
  end

  context "with just the command name" do
    it "shows all completions" do
      expect(response).to eq %w[--help --version download list upload]
    end
  end

  context "with a partial sub command" do
    let(:compline) { 'ftp downl' }

    it "completes the subcommand" do
      expect(response).to eq %w[download]
    end
  end

  context "with a sub command that lists files" do
    let(:compline) { 'ftp download ' }

    it "shows all subcommand completions" do
      expect(response).to eq %w[--help --override another-dir dummy-dir ftp.yaml]
    end
  end

  context "with a sub command that lists directories" do
    let(:compline) { 'ftp upload ' }

    it "shows all subcommand completions" do
      expect(response).to eq %w[--confirm --help another-dir dummy-dir]
    end
  end

  context "with command that contains spaces" do
    let(:compline) { 'ftp connect ssh ' }

    it "shows completions" do
      expect(response).to eq %w[--keyfile]
    end
  end

  context "with command that contains a wildcard" do
    let(:compline) { 'ftp connect --protocol ' }

    it "shows completions" do
      expect(response).to eq %w[scp sftp]
    end
  end

  context "when the command is prefixed by a path" do
    let(:compline) { '/anything/goes/ftp list ' }

    it "shows all subcommand completions" do
      expect(response).to eq %w[--help --short]
    end
  end  
end
