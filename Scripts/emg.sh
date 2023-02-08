#!/usr/bin/expect

set EXECUTE_NAME [lindex $argv 0]
set EXPORT_TIGER [lindex $argv 1]
set FILE_EXPORT_PATH [lindex $argv 2]

set timeout 30
spawn lldb -n $EXECUTE_NAME -w

expect {
	"x86_64h-apple-ios-simulator" {
		send "breakpoint set --selector $EXPORT_TIGGER\n"
		send "breakpoint command add -s python 1 -o \"import os; os.system('leaks $EXECUTE_NAME -outputGraph $FILE_EXPORT_PATH')\"\n"
		send "c\n"
	}
}

expect {
	"_cmd=\"$EXPORT_TIGGER\"" {
		send "c\n"
	}
}

