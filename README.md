# parametric-printhead
Build of a parametric printhead encapsulation for the CTC Bizer Dual that replaces one extruder with a cooling assembly and makes it possible to fast-swap the printhead by using ethernet connectors.

## What this is about?
I've experienced a lot of cable breaks with the printhead of my CTC machine, most of them within the Thermocouple wires as they are not meant for a lot of movement. So I decided to replace the wires that run all the way down to the mainboard with a more flexible solution, ethernet cable. This offers me a possibility to easily exchange the printhead too as the connection is just clipped and the printhead only is fixed with two screws on the carriage

## How?
I'm using Ethernet patch connector extension wires (http://amzn.to/2nQmoxb), cut them open and used the cables to connect the fan, extruder and heating element on the printhead with one set of these as well as every connection going to the mainboard with another set of these. In between the two ethernet sockets I'm then using 0,5m patch cables. I've matched everything in red and white to differentiate between the sockets but that is purely cosmetics.

## The Thermocouple should not be routed through normal copper wires?!
True! It does change the temperature (in my case it seems to be around 10°C less than displayed), but this is dependant on the ambient temperature which is also influencing the 3D printing temperature needed in my experience anyway so if there are big ambient temperature changes that might change the hotend temperature I would need to adjust anyway, even before the Thermocouple effect within the cable took enough effect to cause me printing issues. This is not ideal, I've tried to have the MAX6675 reading the Thermocouple at the printhead side and then transmit the SPI bus down to the mainboard too, but this was extremely unreliable as the stepper motor for the extruder caused massive EMI on the readout and sometimes catastrophic false 0°C reads essentially overheating the hotend massively. I'll try to engage this issue with Mk2 if possible with a custom PCB for the hotend that has a ground plane and possibly an EMI shield.

## Mk2? What are the plans?
Currently I want to change the following, this list is subject to change itself however, I'll probably plan some more changes if I see any issues during the tests:
- Better air exhaust design, this was just a first proof of conecpt to see if everything works, the air outlet currently mainly cools the nozzle not the extruded filament, this is bad
- Custom PCB, using the patch extensions was just a way to quickly solve the issue, ideally I want to have a routed and soldered PCB that has ethernet sockets and screw terminals for all the cables coming in, both at the printhead and printer side
- Have the Thermocouple read at the printhead not back at the mainboard, shield SPI bus from EMI noise
