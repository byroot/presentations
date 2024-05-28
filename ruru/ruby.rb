RubyVM::InstructionSequence.compile_option = {
  peephole_optimization: false,
  specialized_instruction: false,
}

class Ruby
  CallData = Struct.new(:method_name, :argc)

  def initialize(program)
    @program = program
  end
end
