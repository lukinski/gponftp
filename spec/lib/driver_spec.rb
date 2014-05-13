require 'spec_helper'

require_relative '../../lib/driver.rb'

describe Driver do
  let(:driver) { Driver.new([]) }

  describe '#new' do
    it 'is instance of Driver' do
      expect(driver).to be_a Driver
    end
  end

  describe '#file_system' do
    it 'responds to file_system method' do
      expect(driver).to respond_to(:file_system)
    end
  end

  describe '#authenticate' do
    it 'receives login and password' do
      #use "{}" block style over "do - end" due to precedence
      expect(driver).to receive(:authenticate).with(:dummy, :secret)
      driver.authenticate(:dummy, :secret)
    end

    it 'accepts any user/password combination' do
      expect(driver.authenticate('dummy', 'pass')).to be true
      expect(driver.authenticate('dummy1', 'pass2')).to be true
    end
  end

end