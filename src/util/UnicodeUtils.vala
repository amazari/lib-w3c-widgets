namespace W3CWidgets.util {


/*
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * A utility class for sanitizing unicode strings in accordance with the rules for 
 * handling normalized text content and attributes set out in the W3C Widgets
 * specification
 */
public class UnicodeUtils {
	
	/**
	 * Normalizes all whitespace and space characters in the given string to 
	 * U+0020, then collapses multiple adjacent spaces to a single space, and
	 * removes any leading and trailing spaces. If the input string is null,
	 * the method returns an empty string ("")
	 * @param in the string to normalize
	 * @return the normalized string
	 */
	public static string normalizeWhitespace(string in){
		return normalize(in, true);
	}
	
	/**
	 * Normalizes all space characters in the given string to 
	 * U+0020, then collapses multiple adjacent spaces to a single space, and
	 * removes any leading and trailing spaces. If the input string is null,
	 * the method returns an empty string ("")
	 * @param in the string to normalize
	 * @return the normalized string
	 */
	public static string normalizeSpaces(string in){
		return normalize(in, false);
	}
	
	/**
	 * Normalizes all space characters (and whitespace if includeWhitespace is set to true) in the given string to 
	 * U+0020, then collapses multiple adjacent spaces to a single space, and
	 * removes any leading and trailing spaces. If the input string is null,
	 * the method returns an empty string ("")
	 * @param in the string to normalize
	 * @param includeWhitespace set to true to normalize whitespace as well as space characters
	 * @return the normalized string
	 */
	private static string normalize(string in, bool includeWhitespace){
		if (in == null) return "";
		// Create a buffer for the string
		StringBuilder buf = new StringBuilder();
		// Iterate over characters in the string and append them to buffer, replacing matching characters with standard spaces
		for (int x=0;x<in.length;x++){
			char ch = in.get(x);
			if (ch.isspace() && includeWhitespace){
				ch = ' ';
			}
			buf.append_c(ch);
		}
		string str = buf.str;
		// Strip off trailing and leading spaces
		return str.strip();
	}

}
}
