// test_JL_SCAD
//
// Enclosure for LogicAnalyzer
// 2024-10-23 by Torfinn Ingolfsen
//
include <jl_scad/box.scad>
include <jl_scad/parts.scad>
include <jl_scad/utils.scad>

$fs=$preview?0.5:0.125;
$fa = 1;

clearance = 0.7;                    // add clearance to allow pcb to fit into case

pcb_horizontal = 57 + clearance; 
pcb_vertical = 55.2 + clearance;
box_height = 20;

conn_j1_width = 40;                 // input connector
conn_j1_height = 10;                 // was: 5

conn_j2_width = 9;                  // daisy chain top
conn_j2_height = 3;                 // female
conn_j3_width = conn_j2_width;      // daisy chain bottom
conn_j3_height = conn_j2_height;    // male
conn_j3_left_offset = 9.5;          // was: 7.5
conn_j3_bottom_offset = 8;
                                    // The shell of the usb connector needs to fit into
                                    // the slot (to make the conatct engage fully)
                                    // shell measurements: 10.7 x 7.7, 10.86 x 6.6
conn_usb_width = 12;                // was: 11, 10
conn_usb_height = 8;                /* was: 5, conn_usb_height = 3.2; */
conn_usb_left_offset = 33;          // was: 31 mm from left edge of pcb
conn_usb_bottom_offset = 4;         // was: 3, 11.5

case_thickness = 2;
rim_lip = 3;
fudge = 0.01;
standoff_offset = 2 + case_thickness;   // standoffs are for the pcb holes. The holes are located 4mm from edges of pcb
                                        // remove 2 mm
standoff_bot_height = 2;                // bottom standoff height
standoff_top_height = 14;               // was: 15, 16, 17, top part standoff height

$J2_offs = -pcb_vertical/2 + conn_j3_left_offset;
echo("J2 left offset", $J2_offs);

box_make(print=false, explode=0.1, hide_box=false)
box_shell_base_lid([pcb_horizontal,pcb_vertical,box_height], rim_height=rim_lip)
{
    // --- J1 - input connector on the left side
    Z(- box_height / 2) box_part(LEFT) box_cutout(rect([conn_j1_width,conn_j1_height + rim_lip + fudge], anchor=BOT));
    // --- J2 daisy chain connector at pcb top (back of box)
    //Z(-10) box_part(FRONT) box_cutout(rect([conn_j3_width, conn_j3_height], anchor=CENTER));
    M(-pcb_vertical/2 + conn_j3_left_offset + case_thickness,0,- case_thickness - conn_j3_bottom_offset) box_part(BACK) box_cutout(rect([conn_j2_width, box_height / 2 + rim_lip + fudge], anchor=BOT));
    // --- usb connector (back of box)
    //M(-pcb_vertical/2 + conn_usb_left_offset,0,- case_thickness - conn_usb_bottom_offset) box_part(BACK) box_cutout(rect([conn_usb_width, conn_usb_height], anchor=BOT));
    M(-pcb_vertical/2 + conn_usb_left_offset + case_thickness,0,conn_usb_bottom_offset - case_thickness) box_part(TOP+BACK,BACK) box_cutout(rect([conn_usb_width, conn_usb_height], anchor=BOT));
    //box_part(BACK) box_cutout(rect([conn_usb_width, conn_usb_height]), chamfer=0.5);
    // --- J3 daisy chain connector at pcb bottom (front of box)
    //M(-pcb_vertical/2 + conn_j3_left_offset + case_thickness,0,- case_thickness - conn_j3_bottom_offset) box_part(FRONT) box_cutout(rect([conn_j3_width, box_height / 2 + rim_lip + fudge], anchor=BOT));
    M(-pcb_vertical/2 + conn_j3_left_offset + case_thickness,0, -conn_j3_bottom_offset + case_thickness) box_part(FRONT) box_cutout(rect([conn_j3_width, box_height / 2 + rim_lip + fudge], anchor=BOT));
    
    // text on top - name. Z is how deep the text cut goes
    Z(-0.25) box_part(TOP, inside=false) box_cut() text3d("LogicAnalyzer", h=2, size=7, anchor=BOTTOM);
    // text on top, left side
    M(0.12,-15,-5) box_part(TOP+LEFT,TOP, inside=false, spin=270) box_cut() text3d("Chan 0 - 11  Ext_T", h=0.25, size=3, anchor=RIGHT+BACK);
    // text on bottom, left side. Z is how deep the text cut goes
    Z(0.24) X(-pcb_vertical/2) box_part(BOTTOM, inside=false, spin=90) box_cut() text3d("5V 3V3 GND  Chan 12 - 23", h=0.25, size=3, anchor=BOTTOM);
    // --- standoffs ---
    M(standoff_offset,standoff_offset) box_part(BOT, LEFT+FRONT) standoff(h=standoff_bot_height);
    M(standoff_offset,-standoff_offset) box_part(BOT, LEFT+BACK) standoff(h=standoff_bot_height);
    M(-standoff_offset,standoff_offset) box_part(BOT, RIGHT+FRONT) standoff(h=standoff_bot_height);
    M(-standoff_offset,-standoff_offset) box_part(BOT, RIGHT+BACK) standoff(h=standoff_bot_height);

    M(standoff_offset,standoff_offset) box_part(TOP, LEFT+FRONT) standoff(h=17);
    M(standoff_offset,-standoff_offset) box_part(TOP, LEFT+BACK) standoff(h=17);
    M(-standoff_offset,standoff_offset) box_part(TOP, RIGHT+FRONT) standoff(h=17);
    M(-standoff_offset,-standoff_offset) box_part(TOP, RIGHT+BACK) standoff(h=17);
    
}
