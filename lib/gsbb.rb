class Gsbb < Thor
  no_tasks do
    def stale_branches
      @stale_branches ||= branches.select do |branch|
        commit = branch.commit
        commit.authored_date.to_date < (Date.today - 21)
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

  desc "show", "List stale branches"
  def show
    puts "Stale Branches:"
    stale_branches.each do |branch|
      puts "#{branch.name} - #{branch.commit.author}, #{(Date.today - branch.commit.authored_date.to_date).to_i} days old - #{branch.commit.authored_date.to_date}"
    end
  end

  desc "prune", "Remove all stale branches from remote"
  def prune
  end

  desc "email", "Email each stale branch author requesting branch removal"
  def email
    branch.commit.to_hash['committer']['email'] # win!
  end
end