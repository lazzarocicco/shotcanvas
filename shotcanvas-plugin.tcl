# META NAME shotcanvas (shotcanvas-plugin.tcl)
# META DESCRIPTION V02.3 load a png as patch background 
# META AUTHOR <Lazzaro Ciccolella> lazzarocicco@gmail.com

#    from README file
# 1. Creates a PNG snapshot of canvas (What you see in your pd patch).
# 2. Creates a SVG file that embed the png image you created.
# 3. Automatically loads a png with the same name as the .pd file and places it in your patch as a background.
#

package require Tcl 8.5
package require Tk
package require pdwindow 0.1
package require Img

puts "- shotcanvas-plugin ---------"
puts "  pure data (pd) plugin - lazzaro Ciccolella 2020 marrongiallo.github.io"
puts "  README https://github.com/marrongiallo/shotcanvas"
puts "  V0.2.3"
puts "-------------------------"

::pdwindow::post "shotcanvas-plugin V 0.2.3 - pure data (pd) plugin\n"
::pdwindow::post "lazzaro Ciccolella 2020 marrongiallo.github.io\n"
::pdwindow::post "README https://github.com/marrongiallo/shotcanvas\n"
::pdwindow::post "-------------------------\n"

## shotcanvas-svgcontainer.tcl contain a proc that push the SVG skeleton inside this script 
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
        ::pdwindow::post "$file_to_save_svg saved in $::Shotc::img_folder"
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
		        ::pdwindow::post "old $img_path copied as $img_backup"
			image create photo canvasdata -format window -data $object.c
			canvasdata write $img_path -format png
			image delete canvasdata
			} else {
				image create photo canvasdata -format window -data $object.c
				canvasdata write $img_path -format png
			        ::pdwindow::post "$img_path saved in $::Shotc::img_folder"
				image delete canvasdata
		}

		if {[file exists $svg_path]} {
			file copy $svg_path $svg_backup
		        ::pdwindow::post "old $svg_path copied as $svg_backup"
			::crea_svg $object $img_path $svg_path
			} else {
				::crea_svg $object $img_path $svg_path
		}
}

proc en_dis_item_menu {state msg} {
	.menubar.shot entryconfigure 0 -state $state -label $msg
	#puts "$state - $msg"
}

proc update_img {filename rndId} {
        image create photo $rndId -file $filename
}

proc create_bg {object imgid} {
        if {[file exists $::Shotc::img_folder/[file root $::windowname($object)].png]} {
                ::update_img $::Shotc::img_folder/[file root $::windowname($object)].png $imgid
                $object.c create image 0 0 -anchor nw -image $imgid
        }
}

bind PatchWindow <<Loaded>>  {+create_bg %W "w[expr int([expr rand()* 50000000])]imgid"}
bind PdWindow <FocusIn>  {+en_dis_item_menu "disabled" "only for patch"}
bind PatchWindow <FocusIn>  {+set ::Shotc::current_focused %W;en_dis_item_menu "normal" "crea png";}

set m .menubar
menu $m.shot
$m add cascade -menu $m.shot -label shot -underline 0
$m.shot add command -label "only for patch" -command shot -state disabled

