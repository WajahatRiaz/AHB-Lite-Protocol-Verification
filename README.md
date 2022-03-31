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




## Working Protocol:
The master starts a transfer by driving the address and control signals. These signals
provide information about the address, direction, width of the transfer, and indicate if
the transfer forms part of a burst. Transfers can be of different types for instance single, incrementing bursts that do not wrap at address boundaries, wrapping bursts that wrap at particular address boundaries, etc. The write data bus moves data from the master to a slave, and the read data bus moves data from a slave to the master.
Every transfer consists of two phases:
1) Address phase: one address and control cycle
2) Data phase: one or more cycles for the data.

A slave cannot request that the address phase is extended and therefore all slaves must be capable of sampling the address during this time. However, a slave can request that the master extends the data phase by using a HREADY signal. This signal, when LOW, causes wait states to be inserted into the transfer and enables the slave to have extra time to provide or sample data. The slave uses a response signal to indicate the success or failure of a transfer.

## Global Signals:

| Name          | Destination             | Description                                                                                                                                                   |
|---------------|-------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------|
|     HCLK      |     Clock source        |     Clock source for all operations on the protocol. Input signals are sampled at rising edge and changes in output signals happen   after the rising edge    |
|     HRESTn    |     Reset Controller    |     Asynchronous primary reset for all bus elements                                                                                                           |


## Master Signals: 

| Name                | Destination               | Description                                                                             |
|---------------------|---------------------------|-----------------------------------------------------------------------------------------|
|     HADDR [31:0]    |     Slave and Decoder     |     Address bus of 32 bits                                                              |
|     HBURST [2:0]    |     Slave                 |     Indicates the type of burst signal including   wrapping and incrementing bursts     |
|     HSIZE [2:0]     |     Slave                 |     Indicates the size of transfer from 8 bits to 1024   bits                           |


## Slave Signals: 

| Name                 | Destination         | Description                                                                                       | 
|----------------------|---------------------|---------------------------------------------------------------------------------------------------|
|     HRDATA [31:0]    |     Multiplexor     |     Read data bus to transfer the data from a Slave’s   location to the Master via multiplexor    |   
|     HREADYOUT        |     Multiplexor     |     Indicates transfer has finished on the bus and is   used to extend the data phase             |  
|     HRESP            |     Multiplexor     |     Provides additional information that the transfer   was successful or failed                  |


## Decoder Signals: 

| Name                                                              | Destination  | Description                                                            | 
|-------------------------------------------------------------------|--------------|------------------------------------------------------------------------|
|     HSELx                                                         |     Slave    |     Indicates current transfer is for intended for   selected slave    |

## Multiplexor Signals:

| Name                 | Destination             | Description                                      | 
|----------------------|-------------------------|--------------------------------------------------|
|     HRDATA [31:0]    |     Master              |     Read data bus to rout to Master              |
|     HREADY           |     Master and Slave    |     Indicates completion of previous transfer    |
|     HRESP            |     Master              |     Transfer response                            |
