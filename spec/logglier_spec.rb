describe Logglier do

  context "HTTPS" do
    subject { new_logglier('https://localhost') }

    it { should be_an_instance_of Logger }
    its('logdev.dev') { should be_an_instance_of Logglier::Client::HTTP }

    it_should_behave_like "a logglier enhanced Logger instance"

  end

  context "Syslog TCP" do
    before { TCPSocket.stub(:new) { MockTCPSocket.new } }

    subject { new_logglier('tcp://localhost:12345') }

    it { should be_an_instance_of Logger }
    its('logdev.dev') { should be_an_instance_of Logglier::Client::Syslog }

    it_should_behave_like "a logglier enhanced Logger instance"

  end

  context "Syslog UDP" do
    subject { new_logglier('udp://localhost:12345') }

    it { should be_an_instance_of Logger }
    its('logdev.dev') { should be_an_instance_of Logglier::Client::Syslog }

    it_should_behave_like "a logglier enhanced Logger instance"

  end
end
