
using W3CWidgets;

public static void main (string[] arg) {
	File wgt = File.new_for_path("./clock.wgt");
	string widgetGuid = "http://www.getwookie.org/widgets/test";
	File testfolder = File.new_for_path("/tmp/test_caca");	

	try {
	testfolder.make_directory();
	} catch (IOError e)
	{
		warning (@"Could not create file $(testfolder.get_path()): $(e.message)");
	}
	W3CWidgetFactory fac = new W3CWidgetFactory();
	
	fac.setOutputDirectory ("/tmp/test_caca");
	W3CWidget w = fac.parse_zip (wgt);
	
	testfolder.delete();
}


