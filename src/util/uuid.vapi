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

[CCode(cheader_filename = "uuid/uuid.h", lower_case_cprefix = "uuid_", cprefix = "UUID_")]
namespace Native.LibUUID {
	// Constants

	[CCode(cheader_filename = "uuid/uuid.h", cprefix="UUID_VARIANT_")]	
	public enum  Variant {
	[CCode(cheader_filename = "uuid/uuid.h", cprefix="UUID_VARIANT_")]
	NCS,
	[CCode(cheader_filename = "uuid/uuid.h", cprefix="UUID_VARIANT_")]
	DCE,
	[CCode(cheader_filename = "uuid/uuid.h", cprefix="UUID_VARIANT_")]
	MICROSOFT,
	[CCode(cheader_filename = "uuid/uuid.h", cprefix="UUID_VARIANT_")]
	OTHER
	}
	

	[CCode(cheader_filename = "uuid/uuid.h", cprefix="UUID_TYPE_DCE_")]
	public enum Type {
		[CCode(cheader_filename = "uuid/uuid.h", cprefix="UUID_TYPE_DCE_")]
		TIME,
		[CCode(cheader_filename = "uuid/uuid.h", cprefix="UUID_TYPE_DCE_")]
		RANDOM
	}
	
	[CCode(cname = "time_t")]
	public struct time_t : int{}

	[CCode(cname = "struct timeval")]
	public struct timeval {
		public int tv_sec;
		public int tv_usec;
	}

	[CCode(cname = "uuid_t", cheader_filename = "uuid/uuid.h")]
	public struct UUID : char {}


	[CCode(cheader_filename = "uuid/uuid.h")]	
	public void clear(UUID uu);
	[CCode(cheader_filename = "uuid/uuid.h")]
	public void copy(UUID dest, UUID src);
	[CCode(cheader_filename = "uuid/uuid.h")]
	public void generate(UUID outp);
	[CCode(cheader_filename = "uuid/uuid.h")]
	public void generate_random(UUID outp);
	[CCode(cheader_filename = "uuid/uuid.h")]
	public void generate_time(UUID outp);
	[CCode(cheader_filename = "uuid/uuid.h")]
	public void unparse(UUID uu,
			[CCode(array_length = false, array_null_terminated = false)]
			char[] outp);
	[CCode(cheader_filename = "uuid/uuid.h")]
	public void unparse_upper(UUID uu,
			         [CCode(array_length = false, array_null_terminated = false)]
				 char[] outp);
	[CCode(cheader_filename = "uuid/uuid.h")]
	public void unparse_lower(UUID uu,
				 [CCode(array_length = false, array_null_terminated = false)]
				  char[] outp);
	[CCode(cheader_filename = "uuid/uuid.h")]
	public int compare(UUID uu1, UUID uu2);
	[CCode(cheader_filename = "uuid/uuid.h")]
	public int is_null(UUID uu);
	[CCode(cheader_filename = "uuid/uuid.h")]
	public int parse(string uu_in, UUID outp);
	[CCode(cheader_filename = "uuid/uuid.h")]
	public int type(UUID uu);
	[CCode(cheader_filename = "uuid/uuid.h")]
	public int variant(UUID uu);
	[CCode(cheader_filename = "uuid/uuid.h")]
	public time_t time(UUID uu, out timeval TimeInfo);

	[CCode(cname = "ctime_r", cheader_filename = "time.h")]
	public unowned string unixtime_to_string(ref time_t secs, [CCode(array_length = false,array_null_terminated = false)]
					 char[] ret);

}

