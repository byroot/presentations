RubyVM::InstructionSequence.compile_option = {
  # peephole_optimization: false,
  specialized_instruction: false,
}

class Ruby
  CallData = Struct.new(:method_name, :argc)
  
  def initialize(program)
    @stack = []
    @program = program
    @program_counter = 0
  end

  def read
    value = @program[@program_counter]
    @program_counter += 1
    value
  end

  def run
    loop do
      instruction = read

      puts "pc: #{@program_counter}, isns: #{instruction}, stack: #{@stack}"

      case instruction

      when :putself
        self

      when :putobject
        @stack << read

      when :putstring
        @stack << read.dup

      when :send
        call_data = read
        _block = read
        method_arguments = @stack.pop(call_data.argc)
        receiver = @stack.pop
        method = receiver.method(call_data.method_name)
        result = method.call(*method_arguments)
        @stack << result

      when :branchunless
        address = read
        unless @stack.pop
          @program_counter = address
        end

      when :pop
        @stack.pop

      when :jump
        address = read
        @program_counter = address

      when :leave
        return @stack.last

      else
        abort "\nerror: Unknown instruction #{instruction.inspect}"
      end
    end
  end
end
