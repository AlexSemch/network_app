require 'socket'
TCPServer.open('localhost', 3000){ |server|
    if (session = server.accept)
        session.print "Welcome to server\r\nYou can enter commands: ls <dir> | cd <dir> | shutdown\r\n"
        loop{
            cmd, arg = session.gets.chomp.split
            case cmd
                when "ls"
                    begin
                        session.print Dir[arg || "*"].map{ |str| str + "\r\n" }
                    rescue
                        session.print "No such file or directory - #{ arg.inspect }\r\n"
                    end
                when "cd"
                    begin
                        Dir.chdir(arg)
                        session.print "OK.\r\n"
                    rescue
                        session.print "No such file or directory - #{ arg.inspect }\r\n"
                    end
                when "shutdown"
                    session.close
                    break
                else
                    session.print "Bad command!\r\n"
            end
        }
    end
}