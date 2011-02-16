class FileStreamDecorator : FileStream {
	private FileOutputStream output;
	private FileInputStream input;
	
	public FileStreamDecorator (File file) {
		base ();
		output = file.append_to (FileCreateFlags.NONE);
		input = file.read ();
	}
	

	public new int flush () {
		output.flush ();
	}
	public new int seek (long offset, FileSeek whence) {
		output.seek (offset,(SeekType)whence);
		
		return 0;
	}

	
	public new void rewind () {
		output.rewind ();
	}

	public new size_t read (uint8[] buf, size_t size =1) {
		input.read_all (buf, size);
	}
	
	public new size_t write (uint8[] buf, size_t size =1) {
		return output.write_all (buf, size);
	}

}
