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

namespace org.apache.wookie.w3c {

using org.apache.wookie.w3c.exceptions;

/**
 * A Widget Start Page
 */
public interface IContentEntity : ILocalizedEntity {

	public abstract string getSrc();

	public abstract void setSrc(string src);

	public abstract string getCharSet();

	public abstract void setCharSet(string charSet);

	public abstract string getType();

	public abstract void setType(string type);
	
	public abstract void fromXML(Xml.Node element, string[] locales, string[] encodings, File zip) throws BadManifestException;

}
}
