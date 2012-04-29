require_relative '../../../lib/tamarillo/command'

describe Tamarillo::Command do
  before do
    @stdout = $stdout
    $stdout = StringIO.new
  end

  after do
    $stdout = @stdout
  end

  it "has an execute command" do
    expect { subject.execute }
      .to_not raise_error
  end
end
