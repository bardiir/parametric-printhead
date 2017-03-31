heatbrake_width = 45.8;
heatbrake_height = 12.9 + 0.2;
heatbrake_depth = 15.8 + 0.2;
heatbrake_sunk_at_mount = 3; //TBD

fan_width = 40 + 0.2;
fan_screw_distance = 32.3;
fan_screw_diameter = 2.5;
fan_distance_from_center = 7;
fan_screw_length = 10;
fan_lip_height = 5;

printhead_height = 45.1;

clampscrew_distance_from_heatbrake_end = 43.2;
clampscrew_diameter = 2.8;
clampscrew_distance_between = 10.5;

air_channel_width = 8;
air_channel_from_heatbrake_end = 12.4;
air_channel_backtrack = 5;

wall_thickness = 1.2;

hole_fn = 30;

nozzle_below_heatbrake = 25;
nozzle_distance_from_heatbrake_end = 59.5;
nozzle_diameter = 7;
nozzle_distance_from_heatbrake_back = 9.5;

exhaust_bed_clearance = 2;
exhaust_nozzle_clearance = 4;
exhaust_height = 5;

filament_diameter = 1.75 + 0.2;
filament_guide_height = 2;

filament_tube_diameter = 4.2 + 0.2;
filament_tube_guide_height = 15;

support_clearance = 0.6;

ethernet_socket_width = 19.3;
ethernet_socket_depth = 19.8;
ethernet_socket_height = 29.3;
ethernet_socket_cable_d = 10.2;

stepper_motor_depth = 34;
stepper_motor_width = 42.5;
stepper_motor_connector_depth = 10.3 + 0.5;
stepper_motor_connector_width = 16.3 + 0.5;

top_plate_height = 5;

/// --- CALCULATED

fan_screw_distance_from_wall = (fan_width - fan_screw_distance)/2;
fan_screw_block_size = fan_screw_diameter+fan_screw_distance_from_wall;

module top_plate()
{
    top_plate_width = fan_distance_from_center+nozzle_distance_from_heatbrake_end-heatbrake_width+filament_tube_diameter+stepper_motor_connector_width;
    top_plate_depth = heatbrake_depth+stepper_motor_depth;
    
    difference()
    {
        union()
        {
            //base plate
            translate([-top_plate_width+fan_distance_from_center-wall_thickness,-top_plate_depth+heatbrake_depth,printhead_height])
            resize([top_plate_width,top_plate_depth,top_plate_height])
            cube();
        
            filament_guide();
            filament_tube_guide();
        }
        
        filament_guide_hole();
        filament_tube_guide_hole();
        stepper_connector_cutout();
    }
}

module stepper_connector_cutout()
{
    stepper_motor_connector_distance = (stepper_motor_width - stepper_motor_connector_width)/2;
    
    translate([-stepper_motor_connector_distance-stepper_motor_connector_width,-stepper_motor_depth,printhead_height])
    resize([stepper_motor_connector_width,stepper_motor_connector_depth,top_plate_height])
    cube();
}

module filament_guide()
{
    translate([-(nozzle_distance_from_heatbrake_end-heatbrake_width),nozzle_distance_from_heatbrake_back,printhead_height])
    cylinder($fn=hole_fn,d=(filament_diameter)+(wall_thickness*2),h=filament_guide_height);
}

module filament_guide_hole()
{
    translate([-(nozzle_distance_from_heatbrake_end-heatbrake_width),nozzle_distance_from_heatbrake_back,printhead_height])
    cylinder($fn=hole_fn,d=filament_diameter,h=filament_guide_height);
}

module filament_tube_guide()
{
    translate([-(nozzle_distance_from_heatbrake_end-heatbrake_width),nozzle_distance_from_heatbrake_back,printhead_height+filament_guide_height])
    cylinder($fn=hole_fn,d=(filament_tube_diameter)+(wall_thickness*2),h=filament_tube_guide_height);
}

module filament_tube_guide_hole()
{
    translate([-(nozzle_distance_from_heatbrake_end-heatbrake_width),nozzle_distance_from_heatbrake_back,printhead_height+filament_guide_height])
    cylinder($fn=hole_fn,d=filament_tube_diameter,h=filament_tube_guide_height);
}

module air_channel_connector()
{
    exhaust_width = (air_channel_width*2)+heatbrake_depth+(wall_thickness*2);
    exhaust_radius = exhaust_width/2;
    exhaust_overhang_back = exhaust_radius - nozzle_distance_from_heatbrake_back;
    
    union()
    {
        difference()
        {
            translate([0,0,-nozzle_below_heatbrake+exhaust_bed_clearance])
            linear_extrude(height=exhaust_height)
            polygon([
                [air_channel_backtrack,-air_channel_width-wall_thickness],
                [-(nozzle_distance_from_heatbrake_end - heatbrake_width - ((air_channel_width*2)+heatbrake_depth)/2),-exhaust_overhang_back],
                [-(nozzle_distance_from_heatbrake_end - heatbrake_width - ((air_channel_width*2)+heatbrake_depth)/2),exhaust_width-exhaust_overhang_back],
                [air_channel_backtrack,air_channel_width+heatbrake_depth+wall_thickness]
            ],[[0,1,2,3]]);
    
            air_channel_cutout();
        }
        
        translating_factor = (air_channel_width + heatbrake_depth) / 5;
        
        scale([1,0.02,1])
        air_channel_cutout();
        
        translate([0,translating_factor,0])
        scale([1,0.02,1])
        air_channel_cutout();
        
        translate([0,translating_factor*2,0])
        scale([1,0.02,1])
        air_channel_cutout();
        
        translate([0,translating_factor*3,0])
        scale([1,0.02,1])
        air_channel_cutout();
        
        translate([0,translating_factor*4,0])
        scale([1,0.02,1])
        air_channel_cutout();
    }
}

module air_channel_cutout()
{
    translate([0,0,-nozzle_below_heatbrake+exhaust_bed_clearance+wall_thickness])
    linear_extrude(height=exhaust_height-2*wall_thickness)
    polygon([
        [air_channel_backtrack,-air_channel_width],
        [-(nozzle_distance_from_heatbrake_end - heatbrake_width - ((air_channel_width*2)+heatbrake_depth)/2),-(heatbrake_depth - nozzle_distance_from_heatbrake_back)/2],
        [-(nozzle_distance_from_heatbrake_end - heatbrake_width - ((air_channel_width*2)+heatbrake_depth)/2),air_channel_width+heatbrake_depth+(heatbrake_depth-nozzle_distance_from_heatbrake_back)/2-wall_thickness*2],
       [air_channel_backtrack,air_channel_width+heatbrake_depth]
    ],[[0,1,2,3]]);
}

module air_channel()
{
    max_x = nozzle_below_heatbrake - exhaust_bed_clearance;
    max_y = heatbrake_width-air_channel_from_heatbrake_end-wall_thickness - air_channel_backtrack;
    //max_y = nozzle_distance_from_heatbrake_end - air_channel_from_heatbrake_end;
    
    translate([(heatbrake_width-air_channel_from_heatbrake_end-wall_thickness),-(air_channel_width+wall_thickness),0])
    rotate([0,90,90])
    difference() { 
        linear_extrude(height=(air_channel_width*2)+heatbrake_depth+(wall_thickness*2))
        polygon([
            [0,0],
            [max_x/2,0],
            [max_x,max_y/4],
            [max_x,max_y],
            [max_x-exhaust_height,max_y],
            [max_x-exhaust_height,max_y],
            [0,heatbrake_width-air_channel_from_heatbrake_end-wall_thickness]
        ],[[0,1,2,3,4,5,6]]);
        
        translate([0,0,wall_thickness])
        linear_extrude(height=((air_channel_width*2)+heatbrake_depth))
        polygon([
            [0,wall_thickness],
            [(max_x/2)-wall_thickness,wall_thickness],
            [max_x-wall_thickness,(max_y/4)+wall_thickness],
            [max_x-wall_thickness,max_y],
            [max_x-exhaust_height+wall_thickness,max_y],
            [max_x-exhaust_height+wall_thickness,max_y-wall_thickness],
            [0,heatbrake_width-air_channel_from_heatbrake_end-wall_thickness*2-fan_distance_from_center]
        ],[[0,1,2,3,4,5,6]]);
    }
}

module exhaust_ring()
{
    translate([-(nozzle_distance_from_heatbrake_end-heatbrake_width),nozzle_distance_from_heatbrake_back,-(nozzle_below_heatbrake-exhaust_bed_clearance)])
    union()
    {
        difference()
        {
            union()
            {
                cylinder($fn=hole_fn,d=(air_channel_width*2)+heatbrake_depth+(wall_thickness*2),h=exhaust_height);
            
                resize([((air_channel_width*2)+heatbrake_depth)/2,(air_channel_width*2)+heatbrake_depth+(wall_thickness*2),exhaust_height])
                translate([0,-0.5,0])
                cube();
                
            }
        
            cylinder($fn=hole_fn,d=(exhaust_nozzle_clearance*2)+nozzle_diameter,h=exhaust_height);
        
            translate([0,0,wall_thickness])
            cylinder($fn=hole_fn,d=(air_channel_width*2)+heatbrake_depth,h=exhaust_height-(wall_thickness*2));
        
            translate([0,0,wall_thickness])
            resize([((air_channel_width*3)+heatbrake_depth)/2,(air_channel_width*2)+heatbrake_depth-(wall_thickness*2),exhaust_height-wall_thickness*2])
            translate([0,-0.5,0])
            cube();
            
            //cut through border at front to make nozzle fitting easy
            //translate([-(air_channel_width*2+heatbrake_depth-wall_thickness*2)/2,0,0])
            //rotate([0,0,45])
            //resize([10,10,exhaust_height])
            //translate([-0.5,-0.5,0])
            //cube();
        }
        
        exhaust_spacers();
        
        rotate([0,0,45])
        union()
        {
            exhaust_spacers();
        }
        
        
    }
}

module exhaust_spacers()
{
    move_radius = exhaust_nozzle_clearance+nozzle_diameter/2;
    
    translate([-move_radius-wall_thickness,0,wall_thickness])
    exhaust_spacer();
        
    translate([move_radius,0,wall_thickness])
    exhaust_spacer();
        
    translate([0,-move_radius-wall_thickness,wall_thickness])
    exhaust_spacer();
        
    translate([0,move_radius,wall_thickness])
    exhaust_spacer();
}

module exhaust_spacer()
{
    resize([1,1,exhaust_height-wall_thickness*2])
    cube();
}

module heat_brake()
{
    resize([heatbrake_width,heatbrake_depth,heatbrake_height])
    cube();
}

module fan_mount_inner()
{
    points = [
    [  fan_distance_from_center,  -air_channel_width,  0 ],  //0
    [ heatbrake_width-air_channel_from_heatbrake_end,  -air_channel_width,  0 ],  //1
    [ heatbrake_width-air_channel_from_heatbrake_end,  heatbrake_depth+air_channel_width,  0 ],  //2
    [  fan_distance_from_center,  heatbrake_depth+air_channel_width,  0 ],  //3
    [  fan_distance_from_center,  -(fan_width-heatbrake_depth)/2,  printhead_height ],  //4
    [ fan_width+fan_distance_from_center,  -(fan_width-heatbrake_depth)/2,  printhead_height ],  //5
    [ fan_width+fan_distance_from_center,  ((fan_width-heatbrake_depth)/2)+heatbrake_depth,  printhead_height ],  //6
    [  fan_distance_from_center,  ((fan_width-heatbrake_depth)/2)+heatbrake_depth,  printhead_height ]]; //7
  
    faces = [
    [0,1,2,3],  // bottom
    [4,5,1,0],  // front
    [7,6,5,4],  // top
    [5,6,2,1],  // right
    [6,7,3,2],  // back
    [7,4,0,3]]; // left
  
    polyhedron( points, faces );
}

module fan_mount()
{
    points = [
    [  0,  -(air_channel_width+wall_thickness),  0 ],  //0
    [ heatbrake_width+wall_thickness,  -(air_channel_width+wall_thickness),  0 ],  //1
    [ heatbrake_width+wall_thickness,  heatbrake_depth+air_channel_width+wall_thickness,  0 ],  //2
    [  0,  heatbrake_depth+air_channel_width+wall_thickness,  0 ],  //3
    [  0,  -(((fan_width-heatbrake_depth)/2)+wall_thickness),  printhead_height ],  //4
    [ fan_width+fan_distance_from_center+wall_thickness,  -(((fan_width-heatbrake_depth)/2)+wall_thickness),  printhead_height ],  //5
    [ fan_width+fan_distance_from_center+wall_thickness,  ((fan_width-heatbrake_depth)/2)+heatbrake_depth+wall_thickness,  printhead_height ],  //6
    [  0,  ((fan_width-heatbrake_depth)/2)+heatbrake_depth+wall_thickness,  printhead_height ]]; //7
  
    faces = [
    [0,1,2,3],  // bottom
    [4,5,1,0],  // front
    [7,6,5,4],  // top
    [5,6,2,1],  // right
    [6,7,3,2],  // back
    [7,4,0,3]]; // left
  
    polyhedron( points, faces );
}

module fan_lip()
{
    translate([fan_distance_from_center-wall_thickness,-(((fan_width-heatbrake_depth)/2)+wall_thickness),printhead_height-0.1])
    difference()
    {
        resize([fan_width+wall_thickness*2,fan_width+wall_thickness*2,fan_lip_height])
        cube();
        
        translate([wall_thickness, wall_thickness,0])
        resize([fan_width,fan_width,fan_lip_height])
        cube();
    }
}

module fan_screw_hole()
{
    difference()
    {
        resize([fan_screw_block_size,fan_screw_block_size,fan_screw_length])
        cube();
        
        translate([fan_screw_block_size/2, fan_screw_block_size/2,wall_thickness])
        cylinder($fn=hole_fn,d=fan_screw_diameter,h=fan_screw_length-wall_thickness);
    }
}

module fan_screw_block()
{
    resize([fan_screw_block_size,fan_screw_block_size,fan_screw_length])
    cube();
}

module fan_screw_holes()
{
    translate([fan_distance_from_center,-((fan_width-heatbrake_depth)/2),printhead_height-fan_screw_length])
    fan_screw_hole();
    
    translate([fan_distance_from_center+fan_width-fan_screw_block_size,-((fan_width-heatbrake_depth)/2),printhead_height-fan_screw_length])
    fan_screw_hole();
    
    translate([fan_distance_from_center,((fan_width-heatbrake_depth)/2)+heatbrake_depth-fan_screw_block_size,printhead_height-fan_screw_length])
    fan_screw_hole();
    
    translate([fan_distance_from_center+fan_width-fan_screw_block_size,((fan_width-heatbrake_depth)/2)+heatbrake_depth-fan_screw_block_size,printhead_height-fan_screw_length])
    fan_screw_hole();
}

module fan_screw_blocks()
{
    translate([fan_distance_from_center,-((fan_width-heatbrake_depth)/2),printhead_height-fan_screw_length])
    fan_screw_block();
    
    translate([fan_distance_from_center+fan_width-fan_screw_block_size,-((fan_width-heatbrake_depth)/2),printhead_height-fan_screw_length])
    fan_screw_block();
    
    translate([fan_distance_from_center,((fan_width-heatbrake_depth)/2)+heatbrake_depth-fan_screw_block_size,printhead_height-fan_screw_length])
    fan_screw_block();
    
    translate([fan_distance_from_center+fan_width-fan_screw_block_size,((fan_width-heatbrake_depth)/2)+heatbrake_depth-fan_screw_block_size,printhead_height-fan_screw_length])
    fan_screw_block();
}

module cut_out_for_mount_point()
{
    safety_zone = wall_thickness*2;
    
    translate([heatbrake_width-air_channel_from_heatbrake_end-wall_thickness,-(air_channel_width+wall_thickness+(safety_zone/2)),0])
    resize([air_channel_from_heatbrake_end+wall_thickness,(air_channel_width*2)+(wall_thickness*2)+heatbrake_depth+safety_zone,heatbrake_sunk_at_mount])
    cube();
}

module air_channel_lip()
{
    safety_zone = wall_thickness/2;
    
    translate([heatbrake_width-air_channel_from_heatbrake_end-(wall_thickness*2),-(air_channel_width+wall_thickness+(safety_zone/2)),0])
    resize([air_channel_from_heatbrake_end+wall_thickness,(air_channel_width*2)+(wall_thickness*2)+heatbrake_depth+safety_zone,heatbrake_sunk_at_mount+wall_thickness])
    cube();
}

module print_head()
{
    difference()
    {
        union()
        {
            difference()
            {
                fan_mount();
                fan_mount_inner();
                fan_screw_blocks();
            }
            air_channel_lip();
            fan_screw_holes();
            fan_lip();
            air_channel();
            air_channel_connector();
            exhaust_ring();
            top_plate();
        }
        clampscrew_holes();
        cut_out_for_mount_point();
        heat_brake();
    }
}

module clampscrew_holes()
{
    translate([heatbrake_width-clampscrew_distance_from_heatbrake_end,(heatbrake_depth/2)-(clampscrew_distance_between/2),0])
cylinder(h=printhead_height+top_plate_height,d=clampscrew_diameter,$fn=hole_fn);

translate([heatbrake_width-clampscrew_distance_from_heatbrake_end,(heatbrake_depth/2)+(clampscrew_distance_between/2),0])
cylinder(h=printhead_height+top_plate_height,d=clampscrew_diameter,$fn=hole_fn);
}

module print_head_support()
{
    //heatbrake hole front
    translate([0,support_clearance,support_clearance])
    resize([fan_distance_from_center,heatbrake_depth-support_clearance*2,heatbrake_height-support_clearance*2])
    cube();
    
    //heatbrake hole back
    translate([heatbrake_width-air_channel_from_heatbrake_end-support_clearance,support_clearance,support_clearance])
    resize([air_channel_from_heatbrake_end,heatbrake_depth-support_clearance*2,heatbrake_height-support_clearance*2])
    cube();
    
    //overhang for mount sink
    translate([heatbrake_width-air_channel_from_heatbrake_end,-air_channel_width-wall_thickness,-nozzle_below_heatbrake+exhaust_bed_clearance])
    resize([air_channel_from_heatbrake_end-support_clearance,air_channel_width*2+heatbrake_depth+wall_thickness*2,nozzle_below_heatbrake+heatbrake_sunk_at_mount-exhaust_bed_clearance-support_clearance])
    cube();
    
    //overhang for end wall
    translate([heatbrake_width,-air_channel_width-wall_thickness,-nozzle_below_heatbrake+exhaust_bed_clearance])
    resize([wall_thickness,air_channel_width*2+heatbrake_depth+wall_thickness*2,nozzle_below_heatbrake-exhaust_bed_clearance-support_clearance])
    cube();
}


//cut_out_for_mount_point();
//heat_brake();
union()
{
print_head();
print_head_support();
}

//air_channel();
//air_channel_connector();
//exhaust_ring();