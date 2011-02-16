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

namespace org.apache.wookie.w3c.impl {



using org.apache.wookie.w3c;
using org.apache.wookie.w3c.util;

using Xml;


public errordomain AccessEntityError {
	PARSING
}
/**
 * The Access element is defined in: http://www.w3.org/TR/widgets-access/
 */
public class AccessEntity : Object, IAccessEntity, IElement {

	private string fOrigin;
	private bool fSubDomains;

	public AccessEntity(){
		fOrigin = null;
		fSubDomains = false;
	}
	
	public string getOrigin() {
		return fOrigin;
	}

	public bool hasSubDomains() {
		return fSubDomains;
	}

	public void fromXML(Xml.Node* element) {	
		// Origin is required
		if (element->get_prop(IW3CXMLConfiguration.ORIGIN_ATTRIBUTE)==null) return;
		fOrigin = UnicodeUtils.normalizeSpaces(element->get_prop(IW3CXMLConfiguration.ORIGIN_ATTRIBUTE));
		if (fOrigin == "*") return;
		try {
			processOrigin();
		} catch (GLib.Error e) {
			fOrigin =  null;
			return;
		}
		// Subdomains is optional
		try {
			processSubdomains(element->get_prop(IW3CXMLConfiguration.SUBDOMAINS_ATTRIBUTE));
		} catch (GLib.Error e) {
			fSubDomains = false;
			fOrigin = null;
		}			
	}

	/**
	 * Processes an origin attribute
	 * @throws Error if the origin attribute is not valid
	 */
	private void processOrigin() throws GLib.Error{
		
		/**
		 * Note that the Java implementation of URI is currently broken as it
		 * does not properly support IDNs and IRIs. Because of this we use
		 * URL which is slightly less buggy. 
		 */
		
		if (!IRIValidator.isValidIRI(fOrigin)) 
			throw new AccessEntityError.PARSING("origin is not a valid IRI");
		URI uri = new URI();
		uri.parse (fOrigin);
		if (uri.server == null || uri.server.length == 0) throw new AccessEntityError.PARSING ("origin has no host");
		if (uri.user!=null) throw new AccessEntityError.PARSING ("origin has userinfo");
		if (uri.path!=null && uri.path.length>0) throw new AccessEntityError.PARSING("origin has path information");
		if (uri.fragment!=null) throw new AccessEntityError.PARSING("origin has fragment information");
		if (uri.query!=null) throw new AccessEntityError.PARSING("origin has query information");
		
		// Is the scheme supported?
		if (!Arrays.contains(IW3CXMLConfiguration.SUPPORTED_SCHEMES, uri.scheme))
			throw new AccessEntityError.PARSING("scheme is not supported");
		
		// Default ports
		int port = uri.port;
		if (uri.scheme == "http" && port == -1) port = 80;
		if (uri.scheme == "https" && port == -1) port = 443;
		
		uri.port = port;
		
		fOrigin = uri.save();
	}

	/**
	 * Processes a subdomains attribute
	 * @param subDomains
	 * @throws GLib.Error if the attribute is not valid
	 */
	private void processSubdomains(string subDomains) throws GLib.Error{
			
			if (subDomains == "true"||subDomains == "false"){
				fSubDomains = subDomains.to_bool ();
			} else {
				throw new AccessEntityError.PARSING("subdomains is not a valid bool value");
			}
	}

	public Xml.Node toXml() {
		Xml.Node element = new Xml.Node(IW3CXMLConfiguration.ACCESS_ELEMENT,IW3CXMLConfiguration.MANIFEST_NAMESPACE);
		element.set_prop(IW3CXMLConfiguration.SUBDOMAINS_ATTRIBUTE, hasSubDomains().to_string());
		element.set_prop(IW3CXMLConfiguration.ORIGIN_ATTRIBUTE, getOrigin());
		return element;
	}
}
}
