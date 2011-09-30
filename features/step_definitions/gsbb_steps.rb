When /^I run the app without parameters$/ do
  When %(I run `gsbb`)
end

Then /^the output shows available commands$/ do
  Then %(the output should contain "show")
  Then %(the output should contain "prune")
  Then %(the output should contain "email")
end

Given /^I have stale branches$/ do
  Gsbb.any_instance.stubs(:stale_branches).returns(['stale1', 'stale2'])
end

Then /^the output includes the stale branches$/ do
  Then %(the output should contain "Stale Branches:")
  Then %(the output should contain "stale1")
end