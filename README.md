# parametric-printhead
Build of a parametric printhead encapsulation for the CTC Bizer Dual that replaces one extruder with a cooling assembly and makes it possible to fast-swap the printhead by using ethernet connectors.

## What this is about?
I've experienced a lot of cable breaks with the printhead of my CTC machine, most of them within the Thermocouple wires as they are not meant for a lot of movement. So I decided to replace the wires that run all the way down to the mainboard with a more flexible solution, ethernet cable. This offers me a possibility to easily exchange the printhead too as the connection is just clipped and the printhead only is fixed with two screws on the carriage. If the cable fails again it's not just a 10 seconds fix and a 1€ cost for the cable instead of having to open up the whole cable structure, dig out the failed cable and replace it complete with the thermocouple. They are not prohibitively expensive but they do cost more in the long run to replace.

## How?
I'm using Ethernet patch connector extension wires (http://amzn.to/2nQmoxb), cut them open and used the cables to connect the fan, extruder and heating element on the printhead with one set of these as well as every connection going to the mainboard with another set of these. In between the two ethernet sockets I'm then using 0,5m patch cables. I've matched everything in red and white to differentiate between the sockets but that is purely cosmetics.

## The Thermocouple should not be routed through normal copper wires?!
True! It does change the temperature (in my case it seems to be around 10°C less than displayed), but this is dependant on the ambient temperature which is also influencing the 3D printing temperature needed in my experience anyway so if there are big ambient temperature changes that might change the hotend temperature I would need to adjust anyway, even before the Thermocouple effect within the cable took enough effect to cause me printing issues. This is not ideal, I've tried to have the MAX6675 reading the Thermocouple at the printhead side and then transmit the SPI bus down to the mainboard too, but this was extremely unreliable as the stepper motor for the extruder caused massive EMI on the readout and sometimes catastrophic false 0°C reads essentially overheating the hotend massively. I'll try to engage this issue with Mk2 if possible with a custom PCB for the hotend that has a ground plane and possibly an EMI shield.

## Mk2
This has been changed:
- Better air exhaust design, this was just a first proof of conecpt to see if everything works, the air outlet of Mk1 mainly cools the nozzle not the extruded filament, this is bad
- Custom PCB, using the patch extensions was just quick workaround
- Added some fuses - polyfuses for the heater wires going through ethernet so if one of the connections gets cut it doesn't result in an overload on the remaining one as well as an additional burn fuse on the PCB to prevent the heater current to leave safe levels alltogether

There also have been plans to do these:
- Have the Thermocouple read at the printhead not back at the mainboard, shield SPI bus from EMI noise  
-> Actually this did result in very bad behavior in all Tests, the error margin for the Thermocouple is low enough to work for this case anyway. However it is a little bit depending on the environment temperature this way which is actually good in this case as it errs to higher temperatures measured in hotter environments which lowers the print temperature and actually levels out the error caused by the environment in the first place. But this is only 1-2°C anyway.

- Have an expansion modifier for annnealing the part. Ideally this part, as it is in direct contact with hot elements of the printhead should be annealed to increase it's temperature stability, this however does cause some warping (see this video: https://www.youtube.com/watch?v=CZX8eHC7fws&t=141s), there should be a modifier to take care of this  
-> Currently using aluminium tape to shield the part, works like a charm, no annealing necessary

- Use nuts to screw fan duct and exhaust together  
-> It's now one part anyway, no need to screw it together, but maybe I'll create a Mk3 version that is screwed if someone can't or doesn't want to print big support structures.
