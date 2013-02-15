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
package org.springextensions.actionscript.samples.cafetownsend.command {

	import org.springextensions.actionscript.samples.cafetownsend.model.AppModelLocator;
	import org.springextensions.actionscript.samples.cafetownsend.model.IApplicationModelAware;

	public class CommandBase implements IApplicationModelAware {
		
		public function CommandBase() {
			super();
		}

		private var _model:AppModelLocator;
		public function get model():AppModelLocator {
			return _model;
		}
		public function set model(value:AppModelLocator):void {
			_model = value;
		}
	}
}