# Ruby Remote Code Execution as a Service (RCEaaS)

![Ruby Logo](https://upload.wikimedia.org/wikipedia/commons/thumb/7/73/Ruby_logo.svg/200px-Ruby_logo.svg.png)

Ruby RCEaaS is a Remote Code Execution tool that operates as a service on machines connected to the same network. It uses a C2 file to execute commands remotely and create an installation file on the victim's machine. 

# Disclaimer
This tool is intended for ethical and educational purposes only. The use of this tool to execute unauthorized code on remote systems without explicit permission is illegal and unethical. Use it responsibly and only on systems where you have explicit authorization.

## Features

- Remote Code Execution on connected machines
- Command auto-completion
- Help functionality
- CLI Program
- Command history

## Use
1. Clone the repository:
   ```bash
   git clone https://github.com/Campero727/rceaas
   ```
2. Navigate to the project directory
    ```bash
    cd rceaas
    ```
3. Run the Ruby script to start the RCEaaS service:
    ```bash
    ruby rceaas.rb
    ```
    
## Command Execution

Once inside the application, we will get a CLI, where we can input commands such as

1. Help 
This command will show us all the available options.
    ```bash
    help
    ```
2. exec
This command, followed by the command to be executed on the victim machine, will take care of remotely executing the command.
    ```bash
    exec <command>
    ```
3. HOST
This command will set the IP address of the victim machine to which we will connect to execute commands.
    ```bash
    HOST <ip>
    ```
4. PORT
This command will set the port for communication.
    ```bash
    PORT <port>
    ```
5. connect
This command will establish communication with the victim machine once the IP and port are specified using the HOST and PORT commands.
    ```bash
    connect
    ```
6. make 
This command will create the script to be executed on the victim machine for command execution.
    ```bash
    make <PORT> 
    ```
7. exit
Command to exit the C2 center
    ```bash
    exit
    ```
Note: This tool is for ethical and educational purposes only. Use responsibly and with explicit permission.