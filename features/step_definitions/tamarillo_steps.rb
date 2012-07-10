After do
  # Kill any forked monitor processes.
  Tamarillo::Monitor.stop
  Tamarillo::Monitor.cleanup
end

def tamarillo_path
  Pathname.new("#{current_dir}/tamarillo")
end

def default_config
  Tamarillo::Config2.new(tamarillo_path.join('config.json'))
end

def clear_tomatoes
  # Not happy with how specific to implementation this is.
  # Giving the storage system a way to remove tomatoes might be good.
  in_current_dir do
    year = Time.new.year
    FileUtils.remove_dir("tamarillo/#{year}", :force)
  end
end

Given /^the default configuration$/ do
  Tamarillo::Storage::FileSystem.new(tamarillo_path, default_config)
end

Given /^there is no active tomato$/ do
  clear_tomatoes
end

Given /^there is an active tomato$/ do
  tomato = Tamarillo::Tomato.new(Time.now, 25 * 60)
  storage = Tamarillo::Storage::FileSystem.new(tamarillo_path, default_config)
  storage.write_tomato(tomato)
end

Given /^there is a completed tomato$/ do
  clear_tomatoes
  time = Time.now - (25 * 60)
  tomato = Tamarillo::Tomato.new(time, 25 * 60)
  storage = Tamarillo::Storage::FileSystem.new(tamarillo_path, default_config)
  storage.write_tomato(tomato)
end


Then /^the output should be empty$/ do
  assert_exact_output('', all_output)
end
