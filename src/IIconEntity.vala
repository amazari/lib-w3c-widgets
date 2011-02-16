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
 * a Widget icon
 */
public abstract interface IIconEntity : ILocalizedEntity {
		
	public abstract string getSrc();

	public abstract void setSrc(string src);

	public abstract int getHeight();

	public abstract void setHeight(int height);

	public abstract int getWidth();

	public abstract void setWidth(int width);
	
	public abstract void fromXML(Xml.Node element, string[] locales, File zip) throws BadManifestException;

}
}