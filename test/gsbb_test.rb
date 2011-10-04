require 'minitest/spec'
require 'minitest/autorun'
require 'pry'
require 'turn'

require File.expand_path(File.join(File.dirname(__FILE__), 'support', 'fake_grit'))
require File.expand_path(File.join(File.dirname(__FILE__), 'support', 'capture_stdout'))

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'gsbb'))
require 'mocha'

describe Gsbb do
  describe "#config" do
    it "delegates to a worker" do
      worker = mock
      worker.expects(:config)
      GsbbWorker.expects(:new).returns(worker)
      Gsbb.start(["config", "--cutoff=21"])
    end

    describe "no params" do
      it "outputs option descriptions" do
        output = capture_stdout { Gsbb.start(["config"]) }
        output.must_match /Cutoff:/
        output.must_match /Output:/
        output.must_match /Include non-merged/
      end
      it "outputs current option values" do
        GsbbWorker.expects(:cutoff).returns("MYCUTOFF")
        GsbbWorker.expects(:output).returns("MYOUTPUTSTRING")
        GsbbWorker.expects(:non_merged?).returns(true)
        output = capture_stdout { Gsbb.start(["config"]) }
        output.must_match /MYCUTOFF/
        output.must_match /MYOUTPUTSTRING/
        output.must_match /true/
      end
      it "requires cutoff be numeric" do
        output = capture_stderr { Gsbb.start(["config", "--cutoff=asdf"]) }
        output.must_match /Expected numeric value/
      end
    end
    describe "flags" do
      it "allows setting the cut-off date" do
        Gsbb.start(["config", "--cutoff=15"])
        # verify it updates the config file
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

      output = capture_stdout { Gsbb.start(["show"]) }

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