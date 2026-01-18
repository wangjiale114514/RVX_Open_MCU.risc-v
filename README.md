# RVX_Open_MCU.risc-v
this is an open-source MCU project. We aim to develop a microcontroller unit from scratch,  Its instruction set is RISC-V

## Here’s our idea for a custom MCU design

We're thinking about building our own MCU from scratch.
The cool part is you can extend its bus right onto the PCB and plug in whatever extra compute modules you want.

## Here’s the rough design we sketched out:

![hello](images/drow.png)

Some of the features we have in mind:

Branch prediction using a simple 2-bit saturating counter

4-stage pipeline:

Fetch

Decode

Get operands

Execute / Push result to bus

The bus is kept lean—either commands are packed tight or sent in timeslots to save pins/wires.
