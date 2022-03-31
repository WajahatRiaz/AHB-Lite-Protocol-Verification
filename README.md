# AHB-Lite Protocol

##Introduction:
Advance High Performance-Lite (AHB-lite) is a bus interface that supports a single bus master
and provides high bandwidth operations. The most common slaves used for this protocol are 
internal memory devices, external memory interfaces, and high bandwidth peripherals.


The main components of the AHB-Lite system are as follows:
1) Master
2) Slave
3) Decoder
4) Multiplexor

An AHB-Lite master provides address and control information to initiate read and write operations. The slave responds to transfers initiated by masters in the system. The slave uses the select signal from the decoder to control when it responds to a bus transfer. The slave signals back to the master i.e., the success, failure, or waiting of the data transfer. This component decodes the address of each transfer and provides a select signal for the slave that is involved in the transfer. It also provides a control signal to the multiplexor. A slave-to-master multiplexor is required to multiplex the read data bus and response signals from the slaves to the master.




##Working Protocol:
The master starts a transfer by driving the address and control signals. These signals
provide information about the address, direction, width of the transfer, and indicate if
the transfer forms part of a burst. Transfers can be of different types for instance single, incrementing bursts that do not wrap at address boundaries, wrapping bursts that wrap at particular address boundaries, etc. The write data bus moves data from the master to a slave, and the read data bus moves data from a slave to the master.
Every transfer consists of two phases:
1) Address phase: one address and control cycle
2) Data phase: one or more cycles for the data.

A slave cannot request that the address phase is extended and therefore all slaves must be capable of sampling the address during this time. However, a slave can request that the master extends the data phase by using a HREADY signal. This signal, when LOW, causes wait states to be inserted into the transfer and enables the slave to have extra time to provide or sample data. The slave uses a response signal to indicate the success or failure of a transfer
