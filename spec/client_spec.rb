require 'spec_helper'
require 'toy_robot'

describe ToyRobot::Client do
  subject(:client) { ToyRobot::Client.new }

  describe 'initial state' do
    it 'has initialized attributes' do
      expect(subject.robot).to be_a ToyRobot::Robot
    end
  end

  describe 'input' do
    it 'accepts command from command line' do
      allow($stdin).to receive(:gets).and_return('PLACE 0,0,NORTH', 'REPORT', '')
      subject.read_console_input
      expect($stdin).to have_received(:gets).exactly(3).times
    end

    it 'accepts empty lines' do
      allow($stdin).to receive(:gets).and_return("\n", '')
      expect { subject.read_console_input }.to output('').to_stdout
      expect($stdin).to have_received(:gets).exactly(2).times
    end

    it 'does nothing on invalid command' do
      allow($stdin).to receive(:gets).and_return('AZERTY', 'QWERTY', 'asd asgtr hrt hrthrt', '')
      expect { subject.read_console_input }.to output('').to_stdout
      expect($stdin).to have_received(:gets).exactly(4).times
    end
  end

  describe 'extended tests' do
    it 'successfully pass test 1' do
      actions = ['PLACE 0,0,NORTH', 'MOVE', 'MOVE', 'REPORT']
      allow($stdin).to receive(:gets).and_return(*actions, '')
      expect { subject.read_console_input }.to output("Output: 0,2,NORTH\n").to_stdout
    end

    it 'successfully pass test 2' do
      actions = ['PLACE 4,3,WEST','MOVE','REPORT']
      allow($stdin).to receive(:gets).and_return(*actions, '')
      expect { subject.read_console_input }.to output("Output: 3,3,WEST\n").to_stdout
    end

    it 'successfully pass test 3' do
      actions = ['PLACE 1,2,EAST', 'MOVE', 'MOVE', 'LEFT', 'MOVE', 'REPORT']
      allow($stdin).to receive(:gets).and_return(*actions, '')
      expect { subject.read_console_input }.to output("Output: 3,3,NORTH\n").to_stdout
    end

    it 'successfully pass test 4' do
      actions = ['PLACE 0,0,NORTH', 'MOVE', 'REPORT']
      allow($stdin).to receive(:gets).and_return(*actions, '')
      expect { subject.read_console_input }.to output("Output: 0,1,NORTH\n").to_stdout
    end

    it 'successfully pass test 5' do
      actions = ['PLACE 0,0,NORTH', 'LEFT', 'REPORT']
      allow($stdin).to receive(:gets).and_return(*actions, '')
      expect { subject.read_console_input }.to output("Output: 0,0,WEST\n").to_stdout
    end

    it 'successfully pass test 6' do
      actions = ['PLACE 0,0,NORTH', 'LEFT', 'LEFT', 'LEFT', 'LEFT', 'REPORT']
      allow($stdin).to receive(:gets).and_return(*actions, '')
      expect { subject.read_console_input }.to output("Output: 0,0,NORTH\n").to_stdout
    end
  end
end
