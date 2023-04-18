# Universal_Memory_Programmer
Tool to program and test onboard memories on a wide range of FPGA boards.  

## Supported Boards
- terasIC DE1  
- terasIC DE2  
- Digilent Nexys 2  
- Digilent Nexys 3  
- DragonBoard (versions 1.0 1.2)  

## What is it for?
This project is intended to program flash and EEPROM memories on FPGA boards.  
It can also be used to program and read SRAM and SDRAM memories, mainly for testing purposes.  
If you are a desperate college student wanting to initialize your SRAM you can program it with this and hope the data is still there after reconfiguring the FPGA...  

## What does it not do?
This project is not intended to program the FPGA configuration memory or the FPGA itself. It is only intended for other external memories.  

## How does it work?
Included in the project files is a python script that you can run on a PC to send and receive commands or data to your board.  
For each supported board you will also find a project folder for ISE, Vivado, or Quartus. The project contains Verilog/SystemVerilog files that describe an SOC with a NeonFox CPU core and all the relevant memory controllers for the board.  
The project folder also includes a mif or coe file with the necessary software to communicate with the python script and control the memories. For boards with more than one memory the software will report the list of available targets and allow you to select one. Run the python script with the --help flag to see how this works.  

## Adding support for more boards
To add support for another board you will need to create a project with the NeonFox CPU core and the relevant memory controllers, then you will need to create a platform header file and one or more libraries.  
You should not modify the main file (neonfox_programmer.asm) except to include the platform header file and your libraries.  
The libraries should have the same interface as the existing ones, so that they can be called from the main file.  
The platform header file should define the addresses used for any modules you add and any variables your libraries need. It should also provide macros to initialize your platform and dynamically bind your libraries to the main file (using function pointers).  
Use the NeonFox macro assembler to assemble your code. The assembler can create bin, mif, and coe files directly.  
