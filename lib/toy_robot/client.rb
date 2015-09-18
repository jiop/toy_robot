module ToyRobot
  class Client
    attr_reader :robot

    def initialize
      @robot = Robot.new
    end

    def read_console_input
      while !(command = $stdin.gets).empty?
        execute_command command
      end
    end

    private
    def execute_command command
      splitted_command = command.split(' ')
      action = splitted_command.first
      args = splitted_command.count > 1 ? splitted_command.last.split(',') : []
      @robot.do_action action, args
    rescue ArgumentError, NoMethodError => e
      puts e.message
    end
  end
end
