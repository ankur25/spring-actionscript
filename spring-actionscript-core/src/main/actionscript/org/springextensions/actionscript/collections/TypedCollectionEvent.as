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
 package org.springextensions.actionscript.collections {

  import flash.events.Event;

  /**
   * Describes an event generated by a TypedCollection
   *
   * <p>
   * <b>Authors:</b> Christophe Herreman, Bert Vandamme<br/>
   * <b>Version:</b> $Revision: 21 $, $Date: 2008-11-01 22:58:42 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
   * <b>Since:</b> 0.1
   * </p>
   */
  public class TypedCollectionEvent extends Event {

	/**
	 * Defines the value of the type property of a <code>TypedCollectionEvent.ADD</code> event object. 
 	 * @eventType String
     */
    public static const ADD:String = "add";

    private var _item:Object;

    /**
     * Creates a new <code>TypedCollectionEvent</code> instance
     *
     * @param type the type of the event
     * @param bubbles a flag indicating whether the event has to bubble or not
     * @param cancelable a flag indicating whether the event can be cancelled or not
     */
    public function TypedCollectionEvent(type:String, item:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
      super(type, bubbles, cancelable);
      _item = item;
    }

    /**
     * Gets the item of the TypedCollectionEvent
     */
    public function get item():Object {
      return _item;
    }
    
    /**
     * Returns an exact copy of the current <code>TypedCollectionEvent</code> instance.
     */
    override public function clone():Event{
    	return new TypedCollectionEvent(this.type, this.item, this.bubbles, this.cancelable);
    }

  }
}
