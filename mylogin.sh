#!/usr/bin/env expect
set relay_server "relay"
set config_name [lindex $argv 0]
//
if {[llength $argv] > 2} {
    send_user "too many arguments\n"
    exit 1
}

if {$config_name == "dev"} {
    set server "cq01-pl42.cq01.baidu.com"
    set username "lizhigang"
    set password "Lzg7758@"
} else {
    exit 1
}

spawn ssh arc -t ssh $relay_server

expect "bash-baidu-ssl"

if {$config_name != "relay"} {
    if {$config_name != "db" && $config_name != "idev"} {
        # Login test server
        send "ssh $username@$server\r"
        expect "password:"
        send "$password\r"
    } else {
        send "ssh $server\r"
    }
}
# From the book "Exploring Expect"
# This is for the program to respond to window size changes.
trap {
    set rows [stty rows]
    set cols [stty columns]
    stty rows $rows columns $cols < $spawn_out(slave,name)
} WINCH

# Happy coding
interact
