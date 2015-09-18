module ToyRobot
  class Robot
    # clockwise array of directions
    AVAILABLE_DIRECTIONS = [:NORTH, :EAST, :SOUTH, :WEST]

    # rapid hash lambda + error management for actions
    ACTIONS = {
      place: ->(robot, args) { robot.place args },
      move: ->(robot, args) { robot.move },
      left: ->(robot, args) { robot.left },
      right: ->(robot, args) { robot.right },
      report: ->(robot, args) { robot.report }
    }
    ACTIONS.default = -> {}

    # rapid hash lambda + error management for moves
    MOVES = {
      NORTH: ->(x, y) { [x, y + 1] },
      SOUTH: ->(x, y) { [x, y - 1] },
      EAST: ->(x, y) { [x + 1, y] },
      WEST: ->(x, y) { [x - 1, y] }
    }
    MOVES.default = ->(x, y) { [x, y] }

    # As the board is not currently variable and has fixed boundaries, we do not need another class
    MAX_BOUND = 4
    MIN_BOUND = 0

    # No magic numbers in methods
    PLACE_METHOD_ARGS_COUNT = 3

    attr_reader :x, :y, :dir, :placed

    def initialize
      @placed = @x = @y = @dir = nil
    end

    # Execute the correct action to the robot
    #
    # == Parameters:
    # action::
    #   A String representing the action to execute.
    # args::
    #   An array of Strings representing the action's arguments
    #
    def do_action action, args = []
      return if action.nil?
      ACTIONS[action.downcase.to_sym].call self, args
    end

    #####################
    # commands

    # Moves the robot to the specified position on the board
    #
    # == Parameters:
    # args::
    #   A String representing the x, y and direction of the robot (comma separated values).
    #
    # == Returns:
    # A boolean indicating if the action was successful
    #
    def place args
      return false unless args.count == PLACE_METHOD_ARGS_COUNT
      x, y, dir = args
      return false unless is_valid_position? x, y
      return false unless is_valid_direction? dir
      @x = x.to_i
      @y = y.to_i
      @dir = dir.to_sym
      @placed = true
    end

    # Displays the current position of the robot
    #
    # == Parameters:
    # args::
    #   A String representing the x, y and direction of the robot (comma separated values).
    #
    # == Returns:
    # A boolean indicating if the action was successful
    #
    def report
      return false if !placed or x.nil? or y.nil? or dir.nil?
      puts "Output: #{x},#{y},#{@dir.to_s}"
      true
    end

    # Moves the robot in the correct direction
    #
    # == Returns:
    # A boolean indicating if the action was successful
    #
    def move
      return false unless placed
      tmp_x, tmp_y = MOVES[@dir].call @x, @y
      return false unless is_valid_position? tmp_x, tmp_y
      @x = tmp_x
      @y = tmp_y
      true
    end

    # Turns the robot to the left
    #
    # == Returns:
    # A boolean indicating if the action was successful
    #
    def left
      return false unless placed
      @dir = AVAILABLE_DIRECTIONS[(AVAILABLE_DIRECTIONS.index(@dir) - 1).modulo(AVAILABLE_DIRECTIONS.count)]
    end

    # Turns the robot to the right
    #
    # == Returns:
    # A boolean indicating if the action was successful
    #
    def right
      return false unless placed
      @dir = AVAILABLE_DIRECTIONS[(AVAILABLE_DIRECTIONS.index(@dir) + 1).modulo(AVAILABLE_DIRECTIONS.count)]
    end

    #####################
    # validations

    # Is a direction valid ?
    #
    # == Parameters:
    # dir::
    #   A String representing the direction to validate.
    #
    # == Returns:
    # A boolean indicating if the direction is valid
    #
    def is_valid_direction? dir
      return false if dir.nil?
      AVAILABLE_DIRECTIONS.include? dir.to_sym
    end

    # Is a position valid ?
    #
    # == Parameters:
    # x::
    #   A String representing the y coordinate.
    # y::
    #   A String representing the x coordinate.
    #
    # == Returns:
    # A boolean indicating if the position is valid
    #
    def is_valid_position? x, y
      x = x.to_i
      y = y.to_i
      return false if x > MAX_BOUND or x < MIN_BOUND or y > MAX_BOUND or y < MIN_BOUND
      true
    end
  end
end
