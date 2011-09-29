#require "gsbb/version"

#module Gsbb
class Gsbb < Thor

  desc "show", "List stale branches"
  def show
    p "puts"
    `echo "echo"`
  end

  desc "prune", "Remove all stale branches from remote"
  def prune
  end

  desc "email", "Email each stale branch author requesting branch removal"
  def email
  end
end
#end