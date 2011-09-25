require 'spec_helper'

describe Retriever do
  before do
    Retriever.config.storage(:ephemeral)
  end

  it 'should fetch ball' do
    Retriever.catch! do
      target :ball do
        'ball'
      end
    end
    Retriever.fetch(:ball).should be_eql('ball')
  end

  it 'should memoize ball' do
    Retriever.catch! do
      target :ball do
        'ball'
      end
    end
    Retriever.storage.should_receive(:set).once.and_return('ball')
    Retriever.fetch(:ball).should be_eql('ball')
    Retriever.storage.stub!(:get).and_return('ball')
    Retriever.fetch(:ball).should be_eql('ball')
  end

  it 'should only be valid in 10 minutes' do
    now = Time.now
    Timecop.freeze(now)
    Retriever.catch! do
      @counter = 0
      target :ball, :validity => 10.minutes do
        @counter += 1
      end
    end
    Retriever.fetch(:ball).should be_eql(1)
    Timecop.freeze(now + 5.minutes)
    Retriever.fetch(:ball).should be_eql(1)
    Timecop.freeze(now + 10.minutes)
    Retriever.fetch(:ball).should be_eql(1)
    Timecop.freeze(now + 10.minutes + 1.second)
    Retriever.fetch(:ball).should be_eql(2)
    Timecop.freeze(now + 15.minutes)
    Retriever.fetch(:ball).should be_eql(2)
    Timecop.freeze(now)
    Retriever.fetch(:ball).should be_eql(2)
    Timecop.freeze(now + 30.minutes)
    Retriever.fetch(:ball).should be_eql(3)
  end

  it 'should be able to pass parameters' do
    Retriever.catch! do
      target :ball do |arg1, arg2|
        arg1 + arg2
      end
    end

    Retriever.fetch(:ball, 1, 2).should be_eql(3)
  end

  it 'should be able to fetch forcefully' do
    now = Time.now
    Timecop.freeze(now)
    Retriever.catch! do
      @counter = 0
      target :ball, :validity => 10.minutes do
        @counter += 1
      end
    end
    Retriever.fetch(:ball).should be_eql(1)
    Retriever.fetch!(:ball).should be_eql(2)
    Retriever.fetch(:ball).should be_eql(2)
  end

  it 'should be encrypted' do
    Retriever.config.encrypt = true
    Retriever.should be_encrypted
    Retriever.catch! do
      target :ball do
        'ball'
      end
    end
    Retriever.fetch(:ball).should be_eql('ball')
  end
end
