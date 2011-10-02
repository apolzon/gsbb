require 'grit'
require 'thor'
class Gsbb < Thor
  no_tasks do
    def stale_branches
      @stale_branches ||= branches.select do |branch|
        commit = branch.commit
        commit.authored_date.to_date < (Date.today + 21)
      end
    end

    def branches
      @branches ||= repo.remotes.reject { |r| r.name =~ /hackfest|HEAD|master|production|staging|performance/ }
      @branches
    end

    def repo
      @repo ||= ::Grit::Repo.new('./')
    end
  end

  desc "config", "Configure overrides to default behavior"
  def config
    # how do we want to do this?
    # gsbb config --cutoff="15 days"
    # gsbb config --exclude="hackfest"
    # gsbb config --only-non-merged

    # ==================================

    # gsbb config
    # What do you want to change?
    # 1. Cutoff Date
    # 2. Exclusion Rule
    # 3. Non-merged branch inclusion

    # Enter new value (#{current_value})
  end

  desc "show", "List stale branches"
  def show
    # git branch --merged shows branches fully merged into master
    output = "Stale Branches:\n"
    stale_branches.each do |branch|
      output << "#{branch.name} - #{branch.commit.author}, #{(Date.today - branch.commit.authored_date.to_date).to_i} days old - #{branch.commit.authored_date.to_date}"
    end
    puts output unless ENV['test']
    output
  end

  desc "prune", "Remove all stale branches from remote"
  def prune
    puts "Pruning:"
    stale_branches.each do |branch|
      name = branch.name.split("/").last

      # Grit breaks here:
      # puts repo.git.native(:push, {:raise => true}, "origin :#{name}")

      puts `git push origin :#{name}`

      if repo.heads.map(&:name).include?(name)
        puts `git branch -D #{name}`
      end
    end
  end

  desc "email", "Email each stale branch author requesting branch removal"
  def email
    stale_branches.each do |branch|
      puts branch.commit.to_hash['committer']['email'] # win!
    end
  end
end