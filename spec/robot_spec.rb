require 'spec_helper'
require 'toy_robot'

describe ToyRobot::Robot do
  describe 'initial state' do
    subject(:robot) { ToyRobot::Robot.new }

    it 'has nil attributes' do
      expect(subject.x).to be_nil
      expect(subject.y).to be_nil
      expect(subject.dir).to be_nil
    end
  end

  describe 'commands' do
    describe 'place' do
      subject(:robot) { ToyRobot::Robot.new }

      context 'when valid arguments are provided' do
        it 'sets robot position to the correct coordinates' do
          subject.do_action 'PLACE', ['0','0','NORTH']
          expect(subject.x).to eq 0
          expect(subject.y).to eq 0
        end

        it 'sets robot position to the correct direction' do
          subject.do_action 'PLACE', ['0','0','NORTH']
          expect(subject.dir).to eq :NORTH
        end
      end

      context 'when invalid arguments are provided' do
        it 'does nothing on the robot coordinates' do
          subject.do_action 'PLACE', ['0','0','NORTH']
          subject.do_action 'PLACE', ['A','A','NORTH']
          expect(subject.x).to eq 0
          expect(subject.y).to eq 0
        end

        it 'does nothing on the robot direction' do
          subject.do_action 'PLACE', ['0','0','NORTH']
          subject.do_action 'PLACE', ['1','1','SOUTHWEST']
          expect(subject.dir).to eq :NORTH
        end
      end
    end

    describe 'left' do
      subject(:robot) { ToyRobot::Robot.new }

      context 'when already placed robot' do
        it 'turns the robot in the specified direction' do
          subject.do_action 'PLACE', ['0','0','NORTH']
          subject.do_action 'LEFT'
          expect(subject.dir).to eq :WEST
        end
      end

      context 'when robot is not yet placed' do
        it 'does nothing' do
          subject.do_action 'LEFT'
          expect(subject.x).to be_nil
          expect(subject.y).to be_nil
          expect(subject.dir).to be_nil
        end
      end
    end

    describe 'right' do
      subject(:robot) { ToyRobot::Robot.new }

      context 'when already placed robot' do
        it 'turns the robot in the specified direction' do
          subject.do_action 'PLACE', ['0','0','NORTH']
          subject.do_action 'RIGHT'
          expect(subject.dir).to eq :EAST
        end
      end

      context 'when robot is not yet placed' do
        it 'does nothing' do
          subject.do_action 'RIGHT'
          expect(subject.x).to be_nil
          expect(subject.y).to be_nil
          expect(subject.dir).to be_nil
        end
      end
    end

    describe 'move' do
      subject(:robot) { ToyRobot::Robot.new }

      context 'when already placed robot' do
        it 'moves the robot in the good direction' do
          subject.do_action 'PLACE', ['0','0','NORTH']
          subject.do_action 'MOVE'
          expect(subject.x).to eq 0
          expect(subject.y).to eq 1
          expect(subject.dir).to eq :NORTH
        end

        it 'does not make the robot fall the board on south' do
          subject.do_action 'PLACE', ['0','0','SOUTH']
          subject.do_action 'MOVE'
          expect(subject.x).to eq 0
          expect(subject.y).to eq 0
          expect(subject.dir).to eq :SOUTH
        end

        it 'does not make the robot fall the board on west' do
          subject.do_action 'PLACE', ['0','0','WEST']
          subject.do_action 'MOVE'
          expect(subject.x).to eq 0
          expect(subject.y).to eq 0
          expect(subject.dir).to eq :WEST
        end

        it 'does not make the robot fall the board on north' do
          subject.do_action 'PLACE', ['4','4','NORTH']
          subject.do_action 'MOVE'
          expect(subject.x).to eq 4
          expect(subject.y).to eq 4
          expect(subject.dir).to eq :NORTH
        end

        it 'does not make the robot fall the board on east' do
          subject.do_action 'PLACE', ['4','4','EAST']
          subject.do_action 'MOVE'
          expect(subject.x).to eq 4
          expect(subject.y).to eq 4
          expect(subject.dir).to eq :EAST
        end
      end

      context 'when robot is not yet placed' do
        it 'does nothing' do
          subject.do_action 'MOVE'
          expect(subject.x).to be_nil
          expect(subject.y).to be_nil
          expect(subject.dir).to be_nil
        end
      end
    end

    describe 'report' do
      subject(:robot) { ToyRobot::Robot.new }

      context 'when already placed robot' do
        it 'outputs the correct current place' do
          subject.do_action 'PLACE', ['0','0','SOUTH']
          expect { subject.do_action 'REPORT' }.to output("Output: 0,0,SOUTH\n").to_stdout
        end
      end

      context 'when robot is not yet placed' do
        it 'does nothing' do
          subject.do_action 'REPORT'
          expect { subject.do_action 'REPORT' }.to_not output("Output: #{subject.x},#{subject.y},#{subject.dir}\n").to_stdout
        end
      end
    end
  end
end
