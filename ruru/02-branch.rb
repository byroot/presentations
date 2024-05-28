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
# 0009 branchunless                           18
# 0011 jump                                   13
# 0013 putobject                              :odd                      (   2)[Li]
# 0015 jump                                   20                        (   1)
# 0017 pop
# 0018 putobject                              :even                     (   4)[Li]
# 0020 leave

result = Ruby.new([
  :putself,
  :putobject, 10,
  :send, Ruby::CallData.new(:rand, 1), nil,
  :send, Ruby::CallData.new(:odd?, 0), nil,
  :branchunless, 18,
  :jump, 13,
  :putobject, :odd,
  :jump, 20,
  :pop,
  :putobject, :even,
  :leave
]).run


puts '-' * 40
puts code
puts
puts "result: #{result.inspect}"
