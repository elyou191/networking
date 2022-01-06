#Copyright (c) 1997 Regents of the University of California.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. All advertising materials mentioning features or use of this software
#    must display the following acknowledgement:
#      This product includes software developed by the Computer Systems
#      Engineering Group at Lawrence Berkeley Laboratory.
# 4. Neither the name of the University nor of the Laboratory may be used
#    to endorse or promote products derived from this software without
#    specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.
#
# $Header: /cvsroot/nsnam/ns-2/tcl/ex/wireless-mitf.tcl,v 1.2 2000/08/30 00:10:45 haoboy Exp $
#
# Simple demo script for the new APIs to support multi-interface for 
# wireless node.
#
# Define options
# Please note: 
# 1. you can still specify "channelType" in node-config right now:
# set val(chan)           Channel/WirelessChannel
# $ns_ node-config ...
#		 -channelType $val(chan)
#                  ...
# But we recommend you to use node-config in the way shown in this script
# for your future simulations.  
# 
# 2. Because the ad-hoc routing agents do not support multiple interfaces
#    currently, this script can't generate anything interesting if you config
#    the interfaces of node 1 and 2 on different channels
#   
#     --Xuan Chen, USC/ISI, July 21, 2000
#
set val(chan)           Channel/WirelessChannel    ;#Channel Type
set val(prop)           Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)          Phy/WirelessPhy            ;# network interface type
set val(mac)            Mac/802_11                 ;# MAC type
set val(ifq)            Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)             LL                         ;# link layer type
set val(ant)            Antenna/OmniAntenna        ;# antenna model
set val(ifqlen)         50                         ;# max packet in ifq
set val(nn)             7                          ;# number of mobilenodes initil n=2
set val(rp)             DSDV                       ;# routing protocol
set val(x)		1000  
set val(y)		1000 

# Initialize Global Variables
set ns_		[new Simulator]
set tracefd     [open sanet2021.tr w]
$ns_ trace-all $tracefd

set namtrace [open sanet2021.nam w]
$ns_ namtrace-all-wireless $namtrace $val(x) $val(y)

# set up topography object
set topo       [new Topography]

$topo load_flatgrid $val(x) $val(y)

# Create God
create-god $val(nn)

# New API to config node: 
# 1. Create channel (or multiple-channels);
# 2. Specify channel in node-config (instead of channelType);
# 3. Create nodes for simulations.

# Create channel #1 and #2
set chan_1_ [new $val(chan)]
#set chan_2_ [new $val(chan)]

# Create node(0) "attached" to channel #1

# configure node, please note the change below.
$ns_ node-config -adhocRouting $val(rp) \
		-llType $val(ll) \
		-macType $val(mac) \
		-ifqType $val(ifq) \
		-ifqLen $val(ifqlen) \
		-antType $val(ant) \
		-propType $val(prop) \
		-phyType $val(netif) \
		-topoInstance $topo \
		-agentTrace ON \
		-routerTrace ON \
		-macTrace ON \
		-movementTrace OFF \
		-channel $chan_1_ 
		
				
for {set i 0} {$i < $val(nn)} {incr i} {
       set node_($i) [$ns_ node]
      $node_($i) random-motion 0           ;#disable random motion
      $ns_ initial_node_pos $node_($i) 50
}





# Provide initial (X,Y, for now Z=0) co-ordinates for mobilenodes
# initial values of  n0 and n1
#$node_(0) set X_ 5.0
#$node_(0) set Y_ 2.0
#$node_(0) set Z_ 0.0

#$node_(1) set X_ 8.0
#$node_(1) set Y_ 5.0
#$node_(1) set Z_ 0.0


# new values
# create position of 7 nodes 
$node_(0) set X_ 50.0
$node_(0) set Y_ 250.0
$node_(0) set Z_ 0.0

$node_(1) set X_ 50.0
$node_(1) set Y_ 500.0
$node_(1) set Z_ 0.0

$node_(2) set X_ 250.0
$node_(2) set Y_ 375.0
$node_(2) set Z_ 0.0

$node_(3) set X_ 450.0
$node_(3) set Y_ 375.0
$node_(3) set Z_ 0.0

$node_(4) set X_ 650.0
$node_(4) set Y_ 375.0
$node_(4) set Z_ 0.0

$node_(5) set X_ 850.0
$node_(5) set Y_ 250.0
$node_(5) set Z_ 0.0

$node_(6) set X_ 850.0
$node_(6) set Y_ 500.0
$node_(6) set Z_ 0.0


# Now produce some simple node movements
# Node_(1) starts to move towards node_(0)

$ns_ at 0.0 "$node_(0) setdest 50.0 250.0 0.0"
$ns_ at 0.0 "$node_(1) setdest 50.0  500.0 0.0"
$ns_ at 0.0 "$node_(2) setdest 250.0 375.0 0.0"
$ns_ at 0.0 "$node_(3) setdest 450.0 375.0 0.0"
$ns_ at 0.0 "$node_(4) setdest 650.0 375.0 0.0"
$ns_ at 0.0 "$node_(5) setdest 850.0 250.0 0.0"
$ns_ at 0.0 "$node_(6) setdest 850.0 500.0 0.0"

# Node_(1) then starts to move away from node_(0)
#$ns_ at 20.0 "$node_(1) setdest 490.0 480.0 30.0" 

# end blok of movement

# Setup traffic flow between nodes
# TCP connections between node_(0) and node_(1)


set tcp0 [new Agent/TCP]
set tcp1 [new Agent/TCP]
set tcp2 [new Agent/TCP]
set tcp3 [new Agent/TCP]
set tcp4 [new Agent/TCP]

#$tcp set class_ 2

$ns_ attach-agent $node_(0) $tcp0
$ns_ attach-agent $node_(1) $tcp1
$ns_ attach-agent $node_(2) $tcp2
$ns_ attach-agent $node_(3) $tcp3
$ns_ attach-agent $node_(4) $tcp4

set sink5 [new Agent/TCPSink]

$ns_ attach-agent $node_(5) $sink5
$ns_ connect $tcp0 $sink5
$ns_ connect $tcp2 $sink5
$ns_ connect $tcp3 $sink5
$ns_ connect $tcp4 $sink5

set sink6 [new Agent/TCPSink]
$ns_ attach-agent $node_(6) $sink6

$ns_ connect $tcp1 $sink6
$ns_ connect $tcp2 $sink6
$ns_ connect $tcp3 $sink6
$ns_ connect $tcp4 $sink6

#$ns_ attach-agent $node_(0) $tcp
#$ns_ attach-agent $node_(1) $sink
#$ns_ connect $tcp $sink
#set ftp [new Application/FTP]
#$ftp attach-agent $tcp
#$ns_ at 3.0 "$ftp start" 

set ftp10 [new Application/FTP]
$ftp10 attach-agent $tcp0
$ns_ at 01.0 "$ftp10 start"

set ftp12 [new Application/FTP]
$ftp12 attach-agent $tcp2
$ns_ at 01.0 "$ftp12 start"

set ftp13 [new Application/FTP]
$ftp13 attach-agent $tcp3
$ns_ at 01.0 "$ftp13 start"

set ftp14 [new Application/FTP]
$ftp14 attach-agent $tcp4
$ns_ at 01.0 "$ftp14 start"


set ftp21 [new Application/FTP]
$ftp21 attach-agent $tcp1
$ns_ at 01.0 "$ftp21 start"

set ftp22 [new Application/FTP]
$ftp22 attach-agent $tcp2
$ns_ at 01.0 "$ftp22 start"

set ftp23 [new Application/FTP]
$ftp23 attach-agent $tcp3
$ns_ at 01.0 "$ftp23 start"

set ftp24 [new Application/FTP]
$ftp24 attach-agent $tcp4
$ns_ at 01.0 "$ftp24 start"

#
# Tell nodes when the simulation ends
#
for {set i 0} {$i < $val(nn) } {incr i} {
    $ns_ at 130.0 "$node_($i) reset";
}
$ns_ at 130.0 "stop"
$ns_ at 130.01 "puts \"NS EXITING...\" ; $ns_ halt"
proc stop {} {
    global ns_ tracefd
    $ns_ flush-trace
    close $tracefd
}

puts "Starting Simulation..."
$ns_ run
