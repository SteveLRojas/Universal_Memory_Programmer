import argparse
import serial 
import time
from enum import Enum
from tqdm import tqdm

# (Get all descriptors)
# - GET_TARGET_DESCRIPTOR
# - get num descriptors
# for num desc:
# 	- set target to n
# 	- get descriptor
# - set desc to idx of matching desc

# (Flag as name)
# - get all descriptors
# - if match, set desc to idx of matching desc

# (Set_target)
# - get all descriptors
# - display list with *current noted
# - set desc to idx of selected desc 

####################
# Constants        #
####################
# CLI Flag Names
BAUD_SHORT = "-b"
BAUD_LONG = "--baud"
PORT_SHORT = "-p"
PORT_LONG = "--port"
FILE_SHORT = "-f"
FILE_LONG = "--file"

# CLI Commands
class Command(Enum):
	READ = 1
	WRITE = 2
	VERIFY = 3
	UNLOCK_ALL = 4
	LOCK_ALL = 5
	GET_STATUS = 6
	ERASE_ALL = 7
	LOCK_BLOCK = 8
	ERASE_BLOCK = 9
	SET_ADDRESS = 10
	GET_PLATFORM_DESCRIPTOR = 11
	GET_TARGET_DESCRIPTOR = 12
	GET_NUM_TARGETS = 13 
	SET_TARGET = 14
	TEST = 15

# Handshake
HS_PINGREQ = "DEADBEEF"
HS_PINGRES = "55AAF00F"

# Response Sizes
PING_RESPONSE_SIZE = 4		# Handshake only
SIZE_RESPONSE_SIZE = 4		# Handshake, Read, Write
#VERIFY_RESPONSE_SIZE = ?	# Verify only
STATUS_RESPONSE_SIZE = 2	# Unlock-All, Lock-All, Get-Status, Erase-All
NUM_TARGETS_SIZE = 1 


####################
# Command Parsers  #
####################
def parseCommand(cleanCommandString):
	if (cleanCommandString == ""):
		print("No command provided!")
		exit(1)

	for cmd in Command:
		if cmd.name == cleanCommandString:
			return cmd

	print("Invalid command provided!")
	exit(1)


####################
# Command Helpers  #
####################
def requireCmdArg(cmdName, argName, arg):
	if not arg:
		print("Missing required argument [" + argName + "] for command " + cmdName + "! Exiting...")
		exit(1)

def connectToBoard(serialObj):
	# Ping w/ $DEADBEEF
	packetPing = bytes.fromhex(HS_PINGREQ)
	serialObj.write(packetPing)

	# Expect $55AAF00F back (or $00000000 for error)
	res = serialObj.read(PING_RESPONSE_SIZE)
	resHexString = ''.join(format(x, '02X') for x in res)

	if (resHexString != HS_PINGRES):
		if (resHexString == "00000000"):	#if we get an error response (size response with value 0)
			print ("Error response from target! Exiting...")
			exit(1)
		else:
			print ("Invalid handshake response from target! Exiting...")
			exit(1)

	# Get and return target board's memory size
	res = serialObj.read(SIZE_RESPONSE_SIZE)
	mem_size = int.from_bytes(res, byteorder='big', signed=False)

	#print("Connected to target board reporting mem_size: [" + str(mem_size) + "]")
	return mem_size

def readTarget(serialObj, maxReadSize=None):
	# Connect & Handshake 
	amtToRead = connectToBoard(serialObj)
	serialObj.timeout = 100

	if (maxReadSize is not None and (maxReadSize < amtToRead)):
			amtToRead = maxReadSize
			print ("maxReadSize is smaller than target, limiting amtToRead to: " + str(amtToRead))
	amtToRead = amtToRead.to_bytes(SIZE_RESPONSE_SIZE, 'big')

	# Send READ Command with amount we'd like to read from the target
	serialObj.write(Command.READ.value.to_bytes(1, 'big'))

	#Command.READ.value.to_bytes(1, 'big')
	serialObj.write(amtToRead)
	# Get total size to read allowed by target
	readCmdRes = serialObj.read(SIZE_RESPONSE_SIZE) 
	readSize = int.from_bytes(readCmdRes, byteorder='big', signed=False)

	# Read data from Target and write to file
	block_size = 1024
	amt_read = 0
	data = bytearray()
	p_bar = tqdm(total = readSize)
	while amt_read < readSize:
		amt_remain = (readSize - amt_read)
		to_read = min(amt_remain, block_size)
		
		data = data + serialObj.read(to_read)

		amt_read = amt_read + to_read
		p_bar.update(to_read)
	p_bar.close()

	#return bytes(data)
	return data

def getTargetDescriptor(serialObj):
	# Connect & Handshake 
	mem_size = connectToBoard(serialObj)

	# Send GET_TARGET_DESCRIPTOR
	serialObj.write(Command.GET_TARGET_DESCRIPTOR.value.to_bytes(1, 'big'))

	desc = serialObj.read_until(expected=b'\x00')
	return desc.decode()[:-1]

def getNumTargets(serialObj):
	# Connect & Handshake 
	mem_size = connectToBoard(serialObj)

	# Send GET_NUM_TARGETS
	serialObj.write(Command.GET_NUM_TARGETS.value.to_bytes(1, 'big'))

	# Get the # of targets
	res = serialObj.read(NUM_TARGETS_SIZE)
	return int.from_bytes(res, byteorder='big', signed=False)

def setTarget(serialObj, newTargetNum):
	# Connect & Handshake 
	mem_size = connectToBoard(serialObj)

	# Send GET_NUM_TARGETS
	serialObj.write(Command.SET_TARGET.value.to_bytes(1, 'big'))

	serialObj.write(newTargetNum.to_bytes(1, 'big'))

def trySetTargetByName(serialObj, newTargetName):
	descriptors = getAllTargetDescriptors(serialObj)

	for i in range(len(descriptors)):
		if (newTargetName == descriptors[i]):
			setTarget(serialObj, i)
			return

	print("Invalid target \'" + newTargetName + "\'  |  Valid targets: " + str(descriptors)) 
	exit(1)

def getAllTargetDescriptors(serialObj):
	# Get the current target's descriptor
	currentDesc = getTargetDescriptor(serialObj)
	#print("currentDesc: [" + currentDesc + "]")

	# Get num descriptors
	numDesc = getNumTargets(serialObj)
	#print("numDesc: [" + str(numDesc) + "]")

	descriptors = []
	currentTarget = 0

	for n in range(numDesc):
		setTarget(serialObj, n)
		desc = getTargetDescriptor(serialObj)
		descriptors.append(desc)
		if (desc == currentDesc):
			#print("\nFound " + desc + " at idx:[" + str(n) + "]\n")
			currentTarget = n 

	# Restore current target & return all descriptors
	setTarget(serialObj, currentTarget)
	return descriptors


####################
# Command Handlers #
####################
def handleRead(serialObj, fileName):
	file = open(fileName,"wb+")

	data = readTarget(serialObj)

	#print(len(data))
	file.write(data)
	file.close()

def handleWrite(serialObj, fileName):
	file = open(fileName,"rb")
	file_data = bytearray(file.read())
	file_size = len(file_data)

	# Connect & Handshake 
	mem_size = connectToBoard(serialObj)
	serialObj.timeout = 30
	serialObj.write_timeout = 1200

	print("Mem size: " + str(mem_size))
	if(file_size > mem_size):
		print("File is larger than memory")
		exit(1)

	# Send WRITE Command
	serialObj.write(Command.WRITE.value.to_bytes(1, 'big'))

	# Send file size
	serialObj.write(file_size.to_bytes(SIZE_RESPONSE_SIZE, 'big'))

	#transfer blocks
	p_bar = tqdm(total = file_size)
	bytes_written = 0
	while bytes_written != file_size:
		res = serialObj.read(SIZE_RESPONSE_SIZE)
		block_size = int.from_bytes(res, byteorder='big', signed=False)
		#print("Block size: " + str(block_size))
		if (block_size == 0):
			print("Error transfering data!")
			exit(1)
		current_block = file_data[bytes_written : bytes_written + block_size]
		serialObj.write(current_block)
		bytes_written = bytes_written + block_size
		p_bar.update(block_size)
	p_bar.close()

	#serialObj.timeout = 10
	#res = serialObj.read(WRITE_CMD_RESPONSE_SIZE)
	#resHexString = ''.join(format(x, '02X') for x in res)
	#print(resHexString)
	time.sleep(1)
	file.close()

def handleVerify(serialObj, fileName):
	file = open(fileName,"rb")
	refData = bytes(file.read())
	refDataLen = len(refData)
	#print("refDataLen: " + str(refDataLen))

	targetData = readTarget(serialObj, refDataLen)
	print("Target data matches reference file? -- " + str(targetData == refData).upper())

	file.close()

def handleUnlockAll(serialObj):
	serialObj.timeout = 3

	# Connect & Handshake 
	mem_size = connectToBoard(serialObj)

	# Send UNLOCK_ALL
	serialObj.write(Command.UNLOCK_ALL.value.to_bytes(1, 'big'))

	# Get status response
	res = serialObj.read(STATUS_RESPONSE_SIZE)
	resHexString = ''.join(format(x, '02X') for x in res)
	print(resHexString)

def handleLockAll(serialObj):
	serialObj.timeout = 5
	
	# Connect & Handshake 
	mem_size = connectToBoard(serialObj)

	# Send LOCK_ALL
	serialObj.write(Command.LOCK_ALL.value.to_bytes(1, 'big'))

	# Get status response
	res = serialObj.read(STATUS_RESPONSE_SIZE)
	resHexString = ''.join(format(x, '02X') for x in res)
	print(resHexString)

def handleGetStatus(serialObj):
	serialObj.timeout = 5

	# Connect & Handshake 
	mem_size = connectToBoard(serialObj)

	# Send GET_STATUS
	serialObj.write(Command.GET_STATUS.value.to_bytes(1, 'big'))

	# Get status response
	res = serialObj.read(STATUS_RESPONSE_SIZE)
	resHexString = ''.join(format(x, '02X') for x in res)
	print(resHexString)

def handleEraseAll(serialObj):
	serialObj.timeout = 20
	
	# Connect & Handshake 
	mem_size = connectToBoard(serialObj)

	# Send ERASE_ALL
	serialObj.write(Command.ERASE_ALL.value.to_bytes(1, 'big'))

	# Get status response
	res = serialObj.read(STATUS_RESPONSE_SIZE)
	resHexString = ''.join(format(x, '02X') for x in res)
	print(resHexString)

def handleGetPlatformDescriptor(serialObj):
	# Connect & Handshake 
	mem_size = connectToBoard(serialObj)

	# Send GET_PLATFORM_DESCRIPTOR
	serialObj.write(Command.GET_PLATFORM_DESCRIPTOR.value.to_bytes(1, 'big'))

	desc = serialObj.read_until(expected=b'\x00')
	print(desc.decode())

def handleGetTargetDescriptor(serialObj):
	targetDesc = getTargetDescriptor(serialObj)
	print("\nCurrent Target: [" + targetDesc + "]\n")

def handleGetNumTargets(serialObj):
	numTargets = getNumTargets(serialObj)
	print("\nNum Targets: [" + str(numTargets) + "]\n")

def handleSetTarget(serialObj):
	descriptors = getAllTargetDescriptors(serialObj)
	numDescriptors = len(descriptors)
	currentDesc = getTargetDescriptor(serialObj)

	sel = 0
	dispString = "\n"
	for i in range(numDescriptors):
		desc = descriptors[i]
		if (desc == currentDesc):
			desc = "*" + desc
		dispString = dispString + str(i + 1) + ". " + desc + "\n"
	dispString = dispString + "\n"

	while(sel == 0):
		print("Enter the number of the target to switch to:")
		userSel = input(dispString)
		if (userSel.isnumeric()):
			sel = int(userSel)
		if (sel > numDescriptors):
			sel = 0
		if (sel == 0):
			print("Invalid selection: enter a number between 1 and " + str(numDescriptors) + "...\n")

	# sel is 1 indexed, subtract one
	setTarget(serialObj, sel - 1)

####################
# Entry            #
####################
def main():
	parser = argparse.ArgumentParser()
	parser.add_argument("command", help="The command to perform " + str([e.name for e in Command]))
	parser.add_argument(BAUD_SHORT, BAUD_LONG, type=int, default=115200, help="The baud rate to set for the serial connection. Defaults to 115200 symbols/sec.")
	parser.add_argument(PORT_SHORT, PORT_LONG, default="COM0", help="The COM port to use. COM0 is used if the flag is not specified.")
	parser.add_argument(FILE_SHORT, FILE_LONG, help="The file to read from for a Write or Verify, or write to for a Read.")
	parser.add_argument("-t", "--target", help="The target to set before operation (also see command SET_TARGET).")
	args = parser.parse_args()

	ser = serial.Serial()
	ser.baudrate = args.baud
	ser.port = args.port
	ser.dsrdtr = False
	ser.dtr = False
	ser.timeout = 1
	ser.open()

	if (args.target):
		trySetTargetByName(ser, args.target.strip())

	cmd = parseCommand(args.command.strip().upper())

	if (cmd == Command.READ):
		requireCmdArg(args.command, FILE_LONG, args.file)
		handleRead(ser, args.file)
	elif (cmd == Command.WRITE):
		requireCmdArg(args.command, FILE_LONG, args.file)
		handleWrite(ser, args.file)
	elif (cmd == Command.VERIFY):
		requireCmdArg(args.command, FILE_LONG, args.file)
		handleVerify(ser, args.file)
	elif (cmd == Command.UNLOCK_ALL):
		handleUnlockAll(ser)
	elif (cmd == Command.LOCK_ALL):
		handleLockAll(ser)
	elif (cmd == Command.GET_STATUS):
		handleGetStatus(ser)
	elif (cmd == Command.ERASE_ALL):
		handleEraseAll(ser)
	elif (cmd == Command.GET_PLATFORM_DESCRIPTOR):
		handleGetPlatformDescriptor(ser)
	elif (cmd == Command.GET_TARGET_DESCRIPTOR):
		handleGetTargetDescriptor(ser)
	elif (cmd == Command.GET_NUM_TARGETS):
		handleGetNumTargets(ser)
	elif (cmd == Command.SET_TARGET):
		handleSetTarget(ser)
	else:
		print("No handler for command! Command:[" + cmd + "]")

	print("Done!")
	ser.close()

if __name__ == "__main__":
    # execute only if run as a script
    main()