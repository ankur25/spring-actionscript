/*
 * Copyright 2007-2008 the original author or authors.
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
package org.springextensions.actionscript.puremvc.testclasses {
  import org.springextensions.actionscript.puremvc.patterns.mediator.IocMediator;

  /**
   * Sample <code>IIocProxy</code> implementation used in tests.
   *
   * <p>
   * <b>Author:</b> Damir Murat<br/>
   * <b>Version:</b> $Revision: 22 $, $Date: 2008-11-01 23:15:06 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
   * <b>Since:</b> 0.6
   * </p>
   */
  public class SampleIocMediator extends IocMediator {
    public function SampleIocMediator(p_mediatorName:String = null, p_viewComponent:Object = null) {
      super(p_mediatorName, p_viewComponent);
    }
  }
}
