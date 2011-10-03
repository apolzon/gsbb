require 'grit'
require 'thor'
require 'gsbb/gsbb_worker'

class Gsbb < Thor
  desc "config", "Configure overrides to default behavior"
  def config
    worker = GsbbWorker.new.config
  end

  desc "show", "List stale branches"
  def show
    worker = GsbbWorker.new.show
  end

  desc "prune", "Remove all stale branches from remote"
  def prune
    worker = GsbbWorker.new.prune
  end

  desc "email", "Email each stale branch author requesting branch removal"
  def email
    worker = GsbbWorker.new.email
  end
end