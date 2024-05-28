require_relative "ruby"

code = <<'RUBY'
  3 + 2
RUBY

puts RubyVM::InstructionSequence.compile(code).disasm
puts '-' * 40

# == disasm: #<ISeq:<compiled>@<compiled>:1 (1,0)-(1,5)>
# 0000 putobject                              3                         (   1)[Li]
# 0002 putobject                              2
# 0004 send                                   <calldata!mid:+, argc:1, ARGS_SIMPLE>, nil
# 0007 leave

result = Ruby.new([
  :putobject, 3,
  :putobject, 2,
  :send, Ruby::CallData.new(:+, 1), nil,
  :leave,
]).run

puts '-' * 40
puts code
puts
puts "result: #{result.inspect}"
