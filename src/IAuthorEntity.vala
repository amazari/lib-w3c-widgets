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

/**
 * an Author of a Widget
 */
public interface IAuthorEntity : ILocalizedEntity {

	public abstract string getAuthorName();

	public abstract void setAuthorName(string authorName);

	public abstract string getHref();

	public abstract void setHref(string href);

	public abstract string getEmail();

	public abstract void setEmail(string email);

}
}
