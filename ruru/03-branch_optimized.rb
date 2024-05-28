require_relative "ruby"

code = <<'RUBY'
  if rand(10).odd?
    :odd
  else
    :even
  end
RUBY

puts RubyVM::InstructionSequence.compile(code).disasm
puts '-' * 40

# == disasm: #<ISeq:<compiled>@<compiled>:1 (1,0)-(5,5)>
# 0000 putself                                                          (   1)[Li]
# 0001 putobject                              10
# 0003 send                                   <calldata!mid:rand, argc:1, FCALL|ARGS_SIMPLE>, nil
# 0006 send                                   <calldata!mid:odd?, argc:0, ARGS_SIMPLE>, nil
# 0009 branchunless                           14
# 0011 putobject                              :odd                      (   2)[Li]
# 0013 leave                                                            (   4)
# 0014 putobject                              :even[Li]
# 0016 leave

result = Ruby.new([
  :putself,
  :putobject, 10,
  :send, Ruby::CallData.new(:rand, 1), nil,
  :send, Ruby::CallData.new(:odd?, 0), nil,
  :branchunless, 14,
  :putobject, :odd,
  :leave,
  :putobject, :even,
  :leave
]).run


puts '-' * 40
puts code
puts
puts "result: #{result.inspect}"
