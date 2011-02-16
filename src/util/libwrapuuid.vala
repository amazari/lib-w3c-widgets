/*
 * libwrapuuid.vala - Wrapper for the simple libuuid bindings.
 * Copyright (c) 2009 Michael B. Trausch &ltmike@trausch.us>
 * License: GNU LGPL v3 as published by the Free Software Foundation
 *
 * This is a wrapper around libuuid.vapi which presents an object-oriented
 * interface to libuuid.
 */

namespace Trausch.Vala.UUID {
	public enum Variant {
		NCS = Native.LibUUID.VARIANT_NCS,
		DCE = Native.LibUUID.VARIANT_DCE,
		Microsoft = Native.LibUUID.VARIANT_MICROSOFT,
		Other = Native.LibUUID.VARIANT_OTHER
	}

	public enum Type {
		Time = Native.LibUUID.TYPE_DCE_TIME,
		Random = Native.LibUUID.TYPE_DCE_RANDOM
	}

	public errordomain UUIDError {
		MALFORMED_STRING_INPUT,
		NOT_SET,
		WRONG_TYPE,
		FAILED
	}

	public class UUID : GLib.Object {
		private Native.LibUUID.UUID uuid;
		private Type defaultType;

		construct {
			this.defaultType = Type.Time;
			this.generate();
		}

		public static UUID create_from_string(string input) throws UUIDError {
			UUID newUUID = new Trausch.Vala.UUID.UUID();
			newUUID.UUID = input;

			return(newUUID);
		}

		public string? UUID {
			owned get {
				if((bool)Native.LibUUID.is_null(this.uuid)) {
					return(null);
				}

				return(this.to_string());
			}

			set {
				if(value == null) {
					Native.LibUUID.clear(this.uuid);
				}

				if(Native.LibUUID.parse(value, this.uuid) < 0) {
					throw new
						UUIDError.MALFORMED_STRING_INPUT("Malformed string");
				}
			}
		}

		public Type UUIDType {
			get {
				if((bool)Native.LibUUID.is_null(this.uuid))
					throw new UUIDError.NOT_SET("No UUID is currently stored");

				Type uuidType = (Type)Native.LibUUID.type(this.uuid);
				return(uuidType);
			}

			set {
				Type current_type = this.UUIDType;
				Type new_type = value;

				if(current_type != new_type) {
					this.defaultType = new_type;
					this.generate();
				}
			}

		}

		public Variant UUIDVariant {
			get {
				if((bool)Native.LibUUID.is_null(this.uuid))
					throw new UUIDError.NOT_SET("No UUID is currently stored");

				Variant uuidVariant =
					(Variant)Native.LibUUID.variant(this.uuid);
				return(uuidVariant);
			}
		}

		public void generate() {
			switch(this.defaultType) {
			case Type.Random:
				Native.LibUUID.generate_random(uuid);
				break;
			case Type.Time:
				Native.LibUUID.generate_time(uuid);
				break;
			default:
				Native.LibUUID.generate(uuid);
				break;
			}
		}

		public int compare(UUID that) {
			return(Native.LibUUID.compare(this.uuid, that.uuid));
		}

		public bool equals(UUID that) {
			bool retval = false;
			int compare_result = Native.LibUUID.compare(this.uuid, that.uuid);
			if(compare_result == 0) retval = true;

			return(retval);
		}

		public UUID duplicate() {
			Trausch.Vala.UUID.UUID newUUID = new Trausch.Vala.UUID.UUID();
			newUUID.UUID = this.to_string();

			return(newUUID);
		}

		public string to_string() {
			char[] chars = new char[37];
			Native.LibUUID.unparse(this.uuid, chars);
			GLib.StringBuilder sb = new GLib.StringBuilder();

			foreach(char c in chars) {
				if(c == '\0') break;

				sb.append_printf("%c", c);
			}

			string retval = sb.str;
			return(retval);
		}

		public void from_string(string input) throws UUIDError {
			this.UUID = input;
		}

		private Native.LibUUID.timeval get_raw_time() throws UUIDError {
			if(this.UUIDType != Type.Time)
				throw new UUIDError.WRONG_TYPE("Invalid op: not a time UUID");

			if((bool)Native.LibUUID.is_null(this.uuid))
				throw new UUIDError.NOT_SET("No UUID is currently stored");

			Native.LibUUID.timeval time;
			Native.LibUUID.time(this.uuid, out time);

			return(time);
		}

		/*
		 * This is a slight bit ugly, to format the time the way I wanted to
		 * do it.
		 */
		public string get_time() throws UUIDError {
			Native.LibUUID.timeval timestamp = this.get_raw_time();
			Native.LibUUID.time_t unixTime =
				(Native.LibUUID.time_t)timestamp.tv_sec;

			GLib.StringBuilder sb = new GLib.StringBuilder();
			char[] timeStr = new char[27];
			Native.LibUUID.unixtime_to_string(ref unixTime, timeStr);

			int spaces = 0;

			foreach(char c in timeStr) {
				if(c == '\n') break;
				if(c == ' ') spaces++;

				if(spaces == 4) {
					sb.append_printf("+%dus", timestamp.tv_usec);
					spaces++;
				}

				sb.append_printf("%c", c);
			}

			return(sb.str);
		}

		public string get_type_as_string() throws UUIDError {
			Type uuidType = this.UUIDType;
			string retval = "";

			switch(uuidType) {
			case Type.Time:
				retval = "Time";
				break;
			case Type.Random:
				retval = "Random";
				break;
			}

			return(retval);
		}

		public string get_variant_as_string() throws UUIDError {
			Variant uuidVariant = this.UUIDVariant;
			string retval = "";

			switch(uuidVariant) {
			case Variant.NCS:
				retval = "NCS";
				break;
			case Variant.DCE:
				retval = "DCE";
				break;
			case Variant.Microsoft:
				retval = "Microsoft";
				break;
			case Variant.Other:
				retval = "Other";
				break;
			}

			return(retval);
		}
	}
}

