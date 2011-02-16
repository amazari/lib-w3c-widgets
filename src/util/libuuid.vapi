/*
 * libuuid.vapi - Vala bindings for the e2fsprogs library libuuid
 * Copyright (c) 2009 Michael B. Trausch <mike@trausch.us>
 * License: GNU LGPL v3 as published by the Free Software Foundation
 *
 * This is a bare simple binding which will be wrapped by a
 * newly-created Vala object.  It's only slightly different than the
 * first version, in that it makes no attempt to make life easier on
 * the programmer using this binding.
 */

[CCode(cheader_filename = "uuid/uuid.h",
	   lower_case_cprefix = "uuid_", cprefix = "UUID_")]
namespace Native.LibUUID {
	// Constants
	private const int VARIANT_NCS;
	private const int VARIANT_DCE;
	private const int VARIANT_MICROSOFT;
	private const int VARIANT_OTHER;
	private const int TYPE_DCE_TIME;
	private const int TYPE_DCE_RANDOM;

	[CCode(cname = "time_t")]
	public struct time_t : int{}

	[CCode(cname = "struct timeval")]
	public struct timeval {
		public int tv_sec;
		public int tv_usec;
	}

	[CCode(cname = "uuid_t")]
	public struct UUID : char {}

	public void clear(UUID uu);
	public void copy(UUID dest, UUID src);
	public void generate(UUID outp);
	public void generate_random(UUID outp);
	public void generate_time(UUID outp);
	public void unparse(UUID uu,
						[CCode(array_length = false,
							   array_nullterminated = false)]
						char[] outp);
	public void unparse_upper(UUID uu,
							  [CCode(array_length = false,
									 array_nullterminated = false)]
							  char[] outp);
	public void unparse_lower(UUID uu,
							  [CCode(array_length = false,
									 array_nullterminated = false)]
							  char[] outp);

	public int compare(UUID uu1, UUID uu2);
	public int is_null(UUID uu);
	public int parse(string uu_in, UUID outp);
	public int type(UUID uu);
	public int variant(UUID uu);

	public time_t time(UUID uu, out timeval TimeInfo);

	[CCode(cname = "ctime_r", cheader_filename = "time.h")]
	public unowned string unixtime_to_string(ref time_t secs,
										  [CCode(array_length = false,
												 array_nullterminated = false)]
										  char[] ret);
}

