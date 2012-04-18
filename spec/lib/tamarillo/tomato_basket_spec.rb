require_relative '../../../lib/tamarillo/tomato_basket'
require 'fakefs/spec_helpers'

include Tamarillo

describe TomatoBasket do
  include FakeFS::SpecHelpers
  let(:tamarillo_dir) { '~/.tamarillo' }
  subject { TomatoBasket.new(tamarillo_dir) }

  it "creates the storage directory if it is missing" do
    FakeFS do
      path = '/tmp'
      expect { TomatoBasket.new(path) }.
        to change { File.directory?(path) }
    end
  end

  it "can write tomatoes to the filesystem"
  it "can read tomatoes from the filesystem"
  it "can count how many tomatoes are stored"
  # something can group them by day and maybe task
end
