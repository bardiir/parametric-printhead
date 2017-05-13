difference()
{
    union()
    {
        translate([30,30,0])
        cylinder(d=8.4,h=20,$fn=100);
        
        resize([60,60,5])
        cube();
    }
    
    translate([30,30,0])
    cylinder(d=4.4,h=20,$fn=100);
}