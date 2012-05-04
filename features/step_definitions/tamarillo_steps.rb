def tamarillo_path
  Pathname.new("#{current_dir}/tamarillo")
end

Given /^the default configuration$/ do
  Tamarillo::Storage.new(tamarillo_path)
  Tamarillo::Config.new.write(tamarillo_path.join('config.yml'))
end

Given /^there is no active tomato$/ do
  # Not happy with how specific to implementation this is.
  # Giving the Storage system a way to remove tomatoes might be good.
  in_current_dir do
    year = Time.new.year
    FileUtils.remove_dir("tamarillo/#{year}", :force)
  end
end

Given /^there is an active tomato$/ do
  clock = Tamarillo::Clock.now
  tomato = Tamarillo::Tomato.new(25 * 60, clock)
  storage = Tamarillo::Storage.new(tamarillo_path)
  path = storage.write(tomato)
end


Then /^the output should be empty$/ do
  assert_exact_output('', all_output)
end
