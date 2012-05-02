Given /^the default configuration$/ do
  # FakeFS::FileSystem.clear
end

Given /^there is an active tomato$/ do
  pending
end

Given /^there is no active tomato$/ do
  in_current_dir do
    year = Time.new.year
    FileUtils.remove_dir("tamarillo/#{year}", :force)
  end
end

Then /^the output should be nothing$/ do
  assert_exact_output('', all_output)
end
