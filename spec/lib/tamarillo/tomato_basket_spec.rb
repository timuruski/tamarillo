require_relative '../../../lib/tamarillo/tomato_basket'
require 'fakefs/spec_helpers'

include Tamarillo

describe TomatoBasket do
  include FakeFS::SpecHelpers
  let(:storage_path) { '~/.tamarillo' }
  subject { TomatoBasket.new(storage_path) }

  it "creates the storage directory if it is missing" do
    FakeFS do
      expect { TomatoBasket.new(storage_path) }.
        to change { File.directory?(storage_path) }
    end
  end

  describe "writing tomatoes to the filesystem" do
    it "writes files" do
      FakeFS do
        now = Time.now
        tomato = stub(:started_at => now, :state => :active)
        tomato_path = Pathname.new(storage_path).join('tomato')

        expect { subject.save(tomato) }.
          to change { File.exist?(tomato_path) }
      end
    end

    describe "tomato file" do
      let(:storage_path) { Pathname.new('/tmp/tamarillo') }
      let(:tomato_path) { storage_path.join('tomato') }

      before do
        now = Time.new(2011,1,1,6,0,0)
        today = Date.new(2011,1,1)
        tomato = stub(:started_at => now, :date => today, :state => :active)
        TomatoBasket.new(storage_path).save(tomato)
      end

      subject { File.readlines(tomato_path.to_s) }

      specify { subject[0].should == '2011-01-01 06:00:00 -0700' }
      specify { subject[1].should == "Some task I'm working on" }
      specify { subject[2].should == 'active' }
    end
  end

  it "can read tomatoes from the filesystem" do
    pending
    FakeFS do
      # insert sample file
      tomato_path = Pathname.new(tamarillo_dir).join('tomato')
      TomatoBasket.load(tomato_path) # should return a tomato
    end
  end


  # A sample tomato basket looks like this:
  # |,tamarillo
  #   |-config
  #   |-basket.sqlite
  #   |-basket
  #     |-2012
  #       |-0401
  #         |-060101
  #

  # it "can count how many tomatoes are stored"
  # it "can find tomatoes by week"
  # it "can find tomatoes by month"
  # something can group them by day and maybe task
end
