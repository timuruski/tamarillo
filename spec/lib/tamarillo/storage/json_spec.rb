require 'tamarillo/storage/json'
require 'tamarillo/tomato'

describe Tamarillo::Storage::JSON do
  let(:params) { { 'path' => 'spec/support/no_tomatoes.json' } }
  let(:tomato) { Tamarillo::Tomato.new(Time.now, (10 * 60)) }

  subject { Tamarillo::Storage::JSON.new(params) }

  # Returns: An array of tomatoes with time offset.
  def tomatoes(*times)
    times.map { |t|
      Tamarillo::Tomato.new(Time.now - t, (10 * 60))
    }
  end

  describe "#initialize" do
    subject { Tamarillo::Storage::JSON.new(params) }

    context "when storage file exists" do
      let(:params) { { 'path' => 'spec/support/sample_tomatoes.json' } }

      # before do
      #   subject = Tamarillo::Storage::JSON.new(params)
      #   subject << Tamarillo::Tomato.new(Time.local(2012,01,01,6,0,0), 600)
      #   subject.write
      # end

      it "loads tomatoes from JSON" do
        subject.should have(1).tomato
      end

      it "restores tomatoes correctly" do
        tomato = subject.latest
        tomato.started_at.should == Time.local(2012,01,01,6,0,0)
        tomato.duration.should == (10 * 60)
      end
    end

    context "when storage file doesn't exist" do
      let(:storage_path) { 'spec/support/invalid_path' }
      let(:params) { { 'path' => storage_path} }

      before do
        File.delete(storage_path) if File.exist?(storage_path)
      end

      after do
        File.delete(storage_path) if File.exist?(storage_path)
      end

      it "generates a default file" do
        subject.should have(0).tomatoes
      end
    end
  end

  describe "#write" do
    it "writes a JSON file"
    it "writes tomatoes to JSON"
  end

  describe "#shovel" do
    it "stores a tomato" do
      expect { subject << tomato }.
        should change { subject.include?(tomato) }
    end

    it "doesn't create duplicates" do
      subject << tomato
      subject << tomato

      subject.count.should == 1
    end
  end

  describe "#count" do
    it "returns the number of tomatoes stored" do
      subject << stub(:tomato)
      subject << stub(:tomato)

      subject.count.should == 2
    end
  end

  describe "#incude?" do
    it "returns true if the tomato is stored" do
      subject << tomato
      subject.include?(tomato).should be_true
    end

    it "returns false if the tomato is not stored" do
      subject.include?(tomato).should be_false
    end
  end

  describe "#latest" do
    it "returns the most recent tomato" do
      a, b, c = tomatoes(1,2,3)

      subject << b
      subject << a
      subject << c

      subject.latest.should == a
    end
  end

  describe "#each" do
    it "yields each tomato in reverse chronological order" do
      a, b, c = tomatoes(1,2,3)

      subject << b
      subject << a
      subject << c

      result = []
      subject.each do |t|
        result << t
      end

      result.should == [a,b,c]
    end
  end

  describe "#.to_a" do
    it "is sorted in reverse chronological order" do
      a, b, c = tomatoes(1,2,3)

      subject << b
      subject << a
      subject << c

      subject.to_a.should == [a,b,c]
    end
  end

end
