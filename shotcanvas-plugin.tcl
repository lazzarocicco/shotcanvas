# META NAME create_entrymenu (create_entrymenu.tcl)
# META DESCRIPTION load a png as patch background 
# META AUTHOR <Lazzaro Ciccolella> lazzarocicco@gmail.com

package require Tcl 8.5
package require Tk
package require pdwindow 0.1
package require Img

puts "- create_entrymenu-plugin ---------"
puts "  pure data (pd) plugin - lazzaro Ciccolella 2020 marrongiallo.github.io"
puts "  README https://github.com/marrongiallo/create_entrymenu"
puts "-------------------------"
## shotcanvas-svgcontainer.tcl contain a proc that pus the SVG skeleton inside this script 
source $::current_plugin_loadpath/shotcanvas-svgcontainer.tcl
##if you have gimp or inkscape installed it should open when the image creation is complete
##set edit_program gimp
set edit_program inkscape

namespace eval Shotc {
   variable current_focused
   variable img_folder "$env(HOME)/Pd/img"
   variable edit_program "inkscape"
}

proc crea_svg {mytop image_to_contain file_to_save_svg} {
        set height [winfo height $mytop.c]
        set width [winfo width  $mytop.c]
        set outputFile [open $file_to_save_svg w]
        ## find out (in the same direcotry) the procedure "svg_container" in svg_container.tcl   
        svg_container $width $height $image_to_contain
        ## NON CANCELLARE "puts $outputFile $::XML" (la riga seguente) il puts non serve a scrivere sulla console ma a riempire il file
        puts $outputFile $::XML
        ## NON CANCELLARE
        close $outputFile
        puts "hai creato il file svg: $file_to_save_svg"
        exec $::Shotc::edit_program $file_to_save_svg  &
}



proc shot {} {
	set object $::Shotc::current_focused
	set img_path $::Shotc::img_folder/[file root $::windowname($object)].png
	set svg_path $::Shotc::img_folder/[file root $::windowname($object)].svg
	set img_backup $::Shotc::img_folder/[file root $::windowname($object)]_[clock format [clock seconds] -format "%y-%m-%d_%H_%M_%S"].png
	set svg_backup $::Shotc::img_folder/[file root $::windowname($object)]_[clock format [clock seconds] -format "%y-%m-%d_%H_%M_%S"].svg
		if {[file exists $img_path]} {
			file copy $img_path $img_backup
			image create photo canvasdata -format window -data $object.c
			canvasdata write $img_path -format png
			image delete canvasdata
			} else {
				image create photo canvasdata -format window -data $object.c
				canvasdata write $img_path -format png
				image delete canvasdata
		}

		if {[file exists $svg_path]} {
			file copy $svg_path $svg_backup
			::crea_svg $object $img_path $svg_path
			} else {
				::crea_svg $object $img_path $svg_path
		}
}

proc en_dis_item_menu {state msg} {
	.menubar.shot entryconfigure 0 -state $state -label $msg
puts "$state - $msg"
}
bind PdWindow <FocusIn>  {+en_dis_item_menu "disabled" "only for patch"}
bind PatchWindow <FocusIn>  {+set ::Shotc::current_focused %W;en_dis_item_menu "normal" "crea png"}

set m .menubar
menu $m.shot
$m add cascade -menu $m.shot -label shot -underline 0
$m.shot add command -label "only for patch" -command shot -state disabled

