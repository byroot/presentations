require_relative "ruby"

code = <<'RUBY'
  "Hello World!"
RUBY

puts RubyVM::InstructionSequence.compile(code).disasm
puts '-' * 40

# == disasm: #<ISeq:<compiled>@<compiled>:1 (1,0)-(1,16)>
# 0000 putstring                              "Hello World!"            (   1)[Li]
# 0002 leave

result = Ruby.new([
  :putstring, "Hello World!".freeze,
  :leave,
]).run

puts '-' * 40
puts code
puts
puts "result: #{result.inspect}"
