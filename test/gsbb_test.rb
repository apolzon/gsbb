require 'minitest/spec'
require 'minitest/autorun'
require 'pry'
require 'turn'

require File.expand_path(File.join(File.dirname(__FILE__), 'support', 'fake_grit'))

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'gsbb'))
require 'mocha'
ENV['test'] = 'true'

describe Gsbb do
  describe "#config" do
    it "delegates to a worker" do
      worker = mock
      worker.expects(:config)
      GsbbWorker.expects(:new).returns(worker)
      Gsbb.start(["config"])
    end

    describe "no params" do
      it "outputs current options" do
        Gsbb.start(["config"]).must_match /cutoff/
        Gsbb.start(["config"]).must_match /output/
        Gsbb.start(["config"]).must_match /non-merged/
      end
    end
    describe "flags" do
      it "allows setting the cut-off date" do
        Gsbb.start(["config", "--cutoff=15"])
      end
      it "allows setting the branch exclusion rule"
      it "allows configuring the output style"
      it "allows excluding non-merged branches by default"
    end
  end

  describe "#show" do
    it "delegates to a worker" do
      worker = mock
      worker.expects(:show)
      GsbbWorker.expects(:new).returns(worker)
      Gsbb.start(["show"])
    end
    
    it "includes author and branch name in output" do
      commit = FakeGrit::Commit.new
      commit.authored_date = Date.today - 22
      commit.author = "Bobby Bobberson"

      branch = FakeGrit::Branch.new
      branch.name = "branchname"
      branch.commit = commit

      repo = FakeGrit::Repo.new
      repo.remotes = [branch]

      Grit::Repo.expects(:new).returns(repo)

      output = Gsbb.start(["show"])

      output.must_match /Bobby Bobberson/
      output.must_match /branchname/
    end
    it "includes merge-status in output"
    it "respects pre-configured cut-off date"
    it "respects pre-configured branch exclusion rule"
    it "respects pre-configured output style"
    it "respects pre-configured non-merge branch behavior"
    it "accepts a flag to exclude non-merged branches"
  end

  describe "#prune" do
    it "delegates to a worker" do
      worker = mock
      worker.expects(:prune)
      GsbbWorker.expects(:new).returns(worker)
      Gsbb.start(["prune"])
    end
  end

  describe "#email" do
    it "delegates to a worker" do
      worker = mock
      worker.expects(:email)
      GsbbWorker.expects(:new).returns(worker)
      Gsbb.start(["email"])
    end
  end
end