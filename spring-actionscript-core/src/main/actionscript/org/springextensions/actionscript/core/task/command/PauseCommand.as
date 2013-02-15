/*
* Copyright 2007-2011 the original author or authors.
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
package org.springextensions.actionscript.core.task.command {

	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.springextensions.actionscript.core.command.ICommand;
	import org.springextensions.actionscript.core.operation.AbstractOperation;
	

	/**
	 * 
	 * @author Roland
	 * @docref the_operation_api.html#tasks
	 */
	public class PauseCommand extends AbstractOperation implements ICommand {

		private var _duration:uint;
		private var _timer:Timer;

		public function PauseCommand(duration:uint) {
			super();
			_duration = duration;
		}
		
		public function execute():* {
			_timer = new Timer(_duration);
			_timer.addEventListener(TimerEvent.TIMER,timerComplete_handler);
			_timer.start();
		}
		
		protected function timerComplete_handler(event:TimerEvent):void {
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER,timerComplete_handler);
			_timer = null;
			dispatchCompleteEvent(null);
		}

	}
}