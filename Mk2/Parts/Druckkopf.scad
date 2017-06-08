/// --- RENDER SELECTION

//air_thingy();
top_plate();
render_printer_connectorplate = 0;

/// --- CALIBRATION VARIABLES

heatbrake_width = 45.8 + 0.5;
heatbrake_height = 12.9 + 0.2;
heatbrake_depth = 15.8 + 0.2;
heatbrake_sunk_at_mount = 3;

fan_width = 40 + 0.2;
fan_screw_distance = 32.3;
fan_screw_diameter = 2.9;
fan_distance_from_center = 7;
fan_screw_length = 5;
fan_lip_height = 5;

board_width = 45.1;
board_height = 33;
board_solder_offset = 2.5;
board_thickness = 1.7;
board_depth = 20-board_thickness;

printhead_height = 45.1;

clampscrew_distance_from_heatbrake_end = 44.8;
clampscrew_diameter = 3 + 0.5 ;
clampscrew_distance_between = 10.5;

air_channel_width = 7;
air_channel_from_heatbrake_end = 16.4;

front_space = 20;

wall_thickness = 1.8;

nozzle_below_heatbrake = 25;
nozzle_distance_from_heatbrake_end = 61.5;
nozzle_diameter = 7;
nozzle_distance_from_heatbrake_back = 9.5;

exhaust_bed_clearance = 2;
exhaust_nozzle_clearance = 20;
exhaust_width = 5;

filament_diameter = 3.5 + 0.2;
filament_tube_diameter = 9 + 0.2;
filament_tube_guide_height = 6.5;

stepper_motor_depth = 34;
stepper_motor_width = 42.5;
stepper_motor_connector_depth = 10.3 + 0.5;
stepper_motor_connector_width = 16.3 + 0.5;

top_plate_height = 5;

/// --- CALCULATED

fan_screw_distance_from_wall = (fan_width - fan_screw_distance)/2;
fan_screw_block_size = fan_screw_diameter+fan_screw_distance_from_wall;

module top_plate() {
    difference() {
        union() {
            translate([heatbrake_width-fan_distance_from_center+wall_thickness,-wall_thickness,printhead_height])
            cube([stepper_motor_width+fan_distance_from_center-wall_thickness,heatbrake_depth+(fan_width-front_space-heatbrake_depth)+wall_thickness*3,top_plate_height]);
            
            translate([heatbrake_width-(board_width+wall_thickness*2),heatbrake_depth+(fan_width-front_space-heatbrake_depth)+wall_thickness*2,printhead_height])
            cube([stepper_motor_width+heatbrake_width+wall_thickness,stepper_motor_depth-(fan_width-heatbrake_depth-front_space+wall_thickness*2)-(board_thickness+wall_thickness*2+5),top_plate_height]);
            
            translate([heatbrake_width,heatbrake_depth,printhead_height])
            cube([stepper_motor_width,stepper_motor_depth,top_plate_height]);
            
            translate([nozzle_distance_from_heatbrake_end,heatbrake_depth-nozzle_distance_from_heatbrake_back,printhead_height+top_plate_height])
            cylinder(d=filament_tube_diameter+wall_thickness*2,h=filament_tube_guide_height,$fn=100);
        }
        
        //filament cutout
        translate([nozzle_distance_from_heatbrake_end,heatbrake_depth-nozzle_distance_from_heatbrake_back,printhead_height])
        cylinder(d=filament_diameter,h=filament_tube_guide_height+top_plate_height,$fn=100);
        
        //tube connector cutout
        translate([nozzle_distance_from_heatbrake_end,heatbrake_depth-nozzle_distance_from_heatbrake_back,printhead_height+top_plate_height])
        cylinder(d=filament_tube_diameter,h=filament_tube_guide_height,$fn=100);
        
        //board cutout
        translate([heatbrake_width-(board_width+wall_thickness)+1,heatbrake_depth+stepper_motor_depth-board_depth-wall_thickness-board_solder_offset,printhead_height-board_height/2])
        cube([board_width-2,board_depth-board_thickness,board_height]);
        
        //stepper connector cutout
        translate([heatbrake_width+((stepper_motor_width-stepper_motor_connector_width)/2),heatbrake_depth+stepper_motor_depth-stepper_motor_connector_depth,stepper_motor_width])
        cube([stepper_motor_connector_width,stepper_motor_connector_depth,10]);
        
        //clamp screw holes
        translate([clampscrew_distance_from_heatbrake_end,(heatbrake_depth-clampscrew_distance_between)/2,heatbrake_height])
        cylinder(d=clampscrew_diameter,h=printhead_height,$fn=100);
        translate([clampscrew_distance_from_heatbrake_end,(heatbrake_depth-clampscrew_distance_between)/2+clampscrew_distance_between,heatbrake_height])
        cylinder(d=clampscrew_diameter,h=printhead_height,$fn=100);
    }
}

module air_thingy() {
    difference() {
        union() {
            //fan lip
            translate([(heatbrake_width-fan_width-wall_thickness-fan_distance_from_center),-front_space,printhead_height+fan_screw_length])
            cube([fan_width+wall_thickness*2,fan_width+wall_thickness*2,fan_lip_height]);
            
            translate([(heatbrake_width-fan_width-wall_thickness-fan_distance_from_center),-front_space,printhead_height])
            cube([fan_width+wall_thickness*2,fan_width+wall_thickness*2,fan_screw_length]);
            
            
            //outer hull fan mount + screw block
            hull() {
                translate([(heatbrake_width-fan_width-wall_thickness-fan_distance_from_center),-front_space,printhead_height])
                cube([fan_width+wall_thickness*2,fan_width+wall_thickness*2,0.01]);
                
                translate([0,-air_channel_width,heatbrake_height])
                cube([heatbrake_width-fan_distance_from_center,heatbrake_depth+air_channel_width*2,1]);    
                
                translate([heatbrake_width-fan_distance_from_center,0,heatbrake_height])
                cube([fan_distance_from_center,heatbrake_depth,printhead_height-heatbrake_height]);
                
                //cable chamber
                translate([heatbrake_width-(board_width+wall_thickness*2),heatbrake_depth,heatbrake_height])
                cube([board_width+wall_thickness*2,stepper_motor_depth,0.01]);
                
                translate([heatbrake_width-(board_width+wall_thickness*2),heatbrake_depth,printhead_height])
                cube([board_width+wall_thickness*2,stepper_motor_depth,0.01]);
                
                //air channel start
                translate([air_channel_from_heatbrake_end,-air_channel_width,heatbrake_height])
                cube([heatbrake_width-air_channel_from_heatbrake_end,air_channel_width,0.01]);
                translate([air_channel_from_heatbrake_end,heatbrake_depth,heatbrake_height])
                cube([heatbrake_width-air_channel_from_heatbrake_end,air_channel_width,0.01]);
            }
            
            //board plate holder on top
            translate([-wall_thickness+heatbrake_width-(board_width+wall_thickness),-5-wall_thickness+heatbrake_depth+stepper_motor_depth-board_thickness-wall_thickness,printhead_height-board_height/2])
            cube([board_width+wall_thickness*2,board_thickness+wall_thickness*2+5,board_height]);
            
            translate([air_channel_from_heatbrake_end,-air_channel_width,0])
            cube([heatbrake_width-air_channel_from_heatbrake_end,air_channel_width,heatbrake_height]);
            translate([air_channel_from_heatbrake_end,heatbrake_depth,0])
            cube([heatbrake_width-air_channel_from_heatbrake_end,air_channel_width,heatbrake_height]);
            
            hull() {
                translate([air_channel_from_heatbrake_end,-air_channel_width,0])
                cube([heatbrake_width-air_channel_from_heatbrake_end,air_channel_width*2+heatbrake_depth,0.001]);
                
                translate([nozzle_distance_from_heatbrake_end-exhaust_nozzle_clearance-nozzle_diameter/2,-air_channel_width,-nozzle_below_heatbrake+exhaust_bed_clearance])
                cube([exhaust_width,air_channel_width*2+heatbrake_depth,0.001]);
            }
        }
        
        //air channel
        translate([air_channel_from_heatbrake_end+wall_thickness,-air_channel_width+wall_thickness,0])
        cube([heatbrake_width-air_channel_from_heatbrake_end-wall_thickness*2,air_channel_width-wall_thickness,heatbrake_height]);
        translate([air_channel_from_heatbrake_end+wall_thickness,heatbrake_depth,0])
        cube([heatbrake_width-air_channel_from_heatbrake_end-wall_thickness*2,air_channel_width-wall_thickness,heatbrake_height]);
        
        //lower exhaust channel
        hull() {
            translate([air_channel_from_heatbrake_end+wall_thickness,-air_channel_width+wall_thickness,0])
            cube([heatbrake_width-air_channel_from_heatbrake_end-wall_thickness*2,air_channel_width*2+heatbrake_depth-wall_thickness*2,0.001]);
            
            translate([nozzle_distance_from_heatbrake_end-exhaust_nozzle_clearance-nozzle_diameter/2+wall_thickness,-air_channel_width+wall_thickness,-nozzle_below_heatbrake+exhaust_bed_clearance])
            cube([exhaust_width-wall_thickness*2,air_channel_width*2+heatbrake_depth-wall_thickness*2,2]);
        }
        
        translate([nozzle_distance_from_heatbrake_end-exhaust_nozzle_clearance-nozzle_diameter/2+wall_thickness,-air_channel_width+wall_thickness,-nozzle_below_heatbrake+exhaust_bed_clearance])
        cube([exhaust_width,air_channel_width*2+heatbrake_depth-wall_thickness*2,2]);
    
        //air channel for fan mount
        hull() {
            translate([(heatbrake_width-fan_width-wall_thickness-fan_distance_from_center)+wall_thickness,-front_space+wall_thickness,printhead_height])
            cube([fan_width,fan_width,0.01]);
            
            translate([wall_thickness+air_channel_from_heatbrake_end,-air_channel_width+wall_thickness,heatbrake_height])
            cube([heatbrake_width-fan_distance_from_center-wall_thickness*2-air_channel_from_heatbrake_end,heatbrake_depth+air_channel_width*2-wall_thickness*2,1]);    
        }
        
        //fan lip
        translate([(heatbrake_width-fan_width-wall_thickness-fan_distance_from_center)+wall_thickness,-front_space+wall_thickness,printhead_height+fan_screw_length])
        cube([fan_width,fan_width,fan_lip_height]);
        
        //fan hole
        translate([(heatbrake_width-fan_width-wall_thickness-fan_distance_from_center)+fan_width/2+wall_thickness,-front_space+fan_width/2+wall_thickness,printhead_height])
        cylinder(d=fan_width,h=fan_screw_length,$fn=30);
        
        //fan screw holes
        translate([(heatbrake_width-fan_width-wall_thickness-fan_distance_from_center),-front_space,printhead_height])
        union() {
            translate([fan_screw_distance_from_wall+wall_thickness,fan_screw_distance_from_wall+wall_thickness,0])
            cylinder(d=fan_screw_diameter,h=fan_screw_length,$fn=10);
            
            translate([fan_screw_distance_from_wall+wall_thickness+fan_screw_distance,fan_screw_distance_from_wall+wall_thickness,0])
            cylinder(d=fan_screw_diameter,h=fan_screw_length,$fn=10);
            
            translate([fan_screw_distance_from_wall+wall_thickness,fan_screw_distance_from_wall+wall_thickness+fan_screw_distance,0])
            cylinder(d=fan_screw_diameter,h=fan_screw_length,$fn=10);
            
            translate([fan_screw_distance_from_wall+wall_thickness+fan_screw_distance,fan_screw_distance_from_wall+wall_thickness+fan_screw_distance,0])
            cylinder(d=fan_screw_diameter,h=fan_screw_length,$fn=10);
        }
            
        hull() {
            translate([heatbrake_width-(board_width+wall_thickness*2)+wall_thickness+1,fan_width-front_space+wall_thickness*2,heatbrake_height+wall_thickness])
            cube([board_width+wall_thickness*2-wall_thickness*2-2,stepper_motor_depth-fan_width+front_space+heatbrake_depth-wall_thickness*3,1]);
            
            translate([heatbrake_width-(board_width+wall_thickness*2)+wall_thickness+1,fan_width-front_space+wall_thickness*2,printhead_height])
            cube([board_width+wall_thickness*2-wall_thickness*2-2,stepper_motor_depth-fan_width+front_space+heatbrake_depth-wall_thickness*3,1]);
        }
        
        //board components
        translate([heatbrake_width-(board_width+wall_thickness)+1,heatbrake_depth+stepper_motor_depth-board_depth-wall_thickness-board_solder_offset,printhead_height-board_height/2])
        cube([board_width-2,board_depth-board_thickness,board_height]);
        
        //board plate
        translate([heatbrake_width-(board_width+wall_thickness),heatbrake_depth+stepper_motor_depth-board_thickness-wall_thickness-board_solder_offset,printhead_height-board_height/2])
        cube([board_width,board_thickness,board_height]);
        
        //board solderoffset
        translate([heatbrake_width-(board_width+wall_thickness)+1,heatbrake_depth+stepper_motor_depth-wall_thickness-board_solder_offset,printhead_height-board_height/2])
        cube([board_width-2,board_solder_offset,board_height]);
        
        //clamp screw holes
        translate([clampscrew_distance_from_heatbrake_end,(heatbrake_depth-clampscrew_distance_between)/2,heatbrake_height])
        cylinder(d=clampscrew_diameter,h=printhead_height,$fn=100);
        translate([clampscrew_distance_from_heatbrake_end,(heatbrake_depth-clampscrew_distance_between)/2+clampscrew_distance_between,heatbrake_height])
        cylinder(d=clampscrew_diameter,h=printhead_height,$fn=100);
        
        //fan cable hole
        translate([(heatbrake_width-fan_width/2-fan_distance_from_center)-2.5,-front_space+fan_width+wall_thickness,printhead_height-wall_thickness])
        cube([5,wall_thickness,fan_lip_height+wall_thickness+fan_screw_length]);
        
        //heater/thermocouple cable hole
        translate([heatbrake_width/2,heatbrake_depth+stepper_motor_depth/2,heatbrake_height])
        cylinder(d=10,h=wall_thickness,$fn=40);
    }
}

%union() {
    cube([heatbrake_width,heatbrake_depth,heatbrake_height]);
    
    translate([heatbrake_width,0,0])
    cube([stepper_motor_width,heatbrake_depth,heatbrake_height]);
    
    translate([heatbrake_width,heatbrake_depth,printhead_height-stepper_motor_width])
    cube([stepper_motor_width,stepper_motor_depth,stepper_motor_width]);
    
    //stepper connector
    translate([heatbrake_width+((stepper_motor_width-stepper_motor_connector_width)/2),heatbrake_depth+stepper_motor_depth-stepper_motor_connector_depth,stepper_motor_width])
    cube([stepper_motor_connector_width,stepper_motor_connector_depth,10]);
    
    translate([nozzle_distance_from_heatbrake_end,heatbrake_depth-nozzle_distance_from_heatbrake_back,-nozzle_below_heatbrake])
    cylinder($fn=20, d=7, h=nozzle_below_heatbrake);
    
    //board components
    translate([heatbrake_width-(board_width+wall_thickness)+1,heatbrake_depth+stepper_motor_depth-board_depth-wall_thickness-board_solder_offset,printhead_height-board_height/2])
    cube([board_width-2,board_depth-board_thickness,board_height]);
    
    //board plate
    translate([heatbrake_width-(board_width+wall_thickness),heatbrake_depth+stepper_motor_depth-board_thickness-wall_thickness-board_solder_offset,printhead_height-board_height/2])
    cube([board_width,board_thickness,board_height]);
    
    //board solderoffset
    translate([heatbrake_width-(board_width+wall_thickness)+1,heatbrake_depth+stepper_motor_depth-wall_thickness-board_solder_offset,printhead_height-board_height/2])
    cube([board_width-2,board_solder_offset,board_height]);
}