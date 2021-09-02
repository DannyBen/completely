require 'spec_helper'

describe "generated script" do
  subject do
    run_completions fixture: fixture, compline: compline, cword: cword
  end

  let(:fixture) { 'ftp' }
  let(:compline) { 'ftp' }
  let(:cword) { compline.split(' ').size }

  context "with just the command name" do
    it "shows all completions" do
      expect(subject).to eq "--help --version download upload list"
    end
  end

  context "with a partial sub command" do
    let(:compline) { 'ftp downl' }
    let(:cword) { 1 }

    it "completes the subcommand" do
      expect(subject).to eq "download"
    end
  end

  context "with a sub command that lists files" do
    let(:compline) { 'ftp download' }

    it "shows all subcommand completions" do
      expect(subject).to eq "another-dir dummy-dir ftp.yaml --help --override"
    end
  end

  context "with a sub command that lists directories" do
    let(:compline) { 'ftp upload' }

    it "shows all subcommand completions" do
      expect(subject).to eq "another-dir dummy-dir --help --confirm"
    end
  end

  context "when the command is prefix by a path" do
    let(:compline) { '/anything/goes/ftp list' }

    it "shows all subcommand completions" do
      expect(subject).to eq "--help --short"
    end
  end  
end
