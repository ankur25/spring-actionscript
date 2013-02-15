/*
 * Copyright 2007-2010 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package testclasses.initdestroy {

	public class ClassWithThreePreDestroyMetadata extends AbstractClassWithPostConstructAndPreDestroyMetadata {

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function ClassWithThreePreDestroyMetadata() {
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		[PreDestroy]
		public function preDestroyMethodA():void {
			_numDestroyMethodsExecuted++;
		}

		[PreDestroy]
		public function preDestroyMethodB():void {
			_numDestroyMethodsExecuted++;
		}

		[PreDestroy]
		public function preDestroyMethodC():void {
			_numDestroyMethodsExecuted++;
		}

	}
}