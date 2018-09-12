require "opentok"
require "set"

opentok = OpenTok::OpenTok.new("46185942", "7e58a0e8bfc5fe6418a08a3c478bcdf8cc61399e")

def create_session
  opentok.create_session
end
