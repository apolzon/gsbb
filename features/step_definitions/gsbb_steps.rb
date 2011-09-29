When /^I run the app without parameters$/ do
  When %(I run `gsbb`)
end

Then /^the output shows available commands$/ do
  Then %(the output should contain "show")
  Then %(the output should contain "prune")
  Then %(the output should contain "email")
end