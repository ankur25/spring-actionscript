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
package org.springextensions.actionscript.utils {

	import flash.utils.Dictionary;

	import mx.collections.ArrayCollection;

	import org.as3commons.lang.ClassUtils;
	import org.springextensions.actionscript.context.support.MXMLApplicationContext;
	import org.springextensions.actionscript.context.support.mxml.Arg;
	import org.springextensions.actionscript.context.support.mxml.MXMLObjectDefinition;
	import org.springextensions.actionscript.context.support.mxml.MethodInvocation;
	import org.springextensions.actionscript.context.support.mxml.Template;
	import org.springextensions.actionscript.ioc.factory.config.RuntimeObjectReference;

	/**
	 * Helper class to generate XML configuration from an <code>MXMLApplicationContext</code> instance.
	 * @author Roland Zwaga
	 * @docref container-documentation.html#generating_an_xml_configuration_from_an_mxmlapplicationcontext
	 */
	public final class MXMLUtils {

		/**
		 * Converts an <code>MXMLApplicationContext</code> instance to a Spring Actionscript XML configuration.
		 * @param context The specified <code>MXMLApplicationContext</code> instance
		 * @return An XML representation of the specified <code>MXMLApplicationContext</code> instance
		 * @docref container-documentation.html#generating_an_xml_configuration_from_an_mxmlapplicationcontext
		 */
		public static function serializeMXMLApplicationContext(context:MXMLApplicationContext):XML {
			XML.ignoreComments = false;
			var contextXML:XML = <objects xmlns="http://www.springactionscript.org/schema/objects"/>;
			var defNs:Namespace = new Namespace("", "http://www.springactionscript.org/schema/objects");
			contextXML.addNamespace(defNs);
			var xsiNs:Namespace = new Namespace("xsi", "http://www.w3.org/2001/XMLSchema-instance");
			contextXML.addNamespace(xsiNs);
			contextXML.@xsiNs::schemaLocation = "http://www.springactionscript.org/schema/objects http://www.springactionscript.org/schema/objects/spring-actionscript-objects-1.0.xsd";

			contextXML.appendChild(<!-- This XML configuration was generated by Spring Actionscript -->);

			for each (var objectDefinition:* in context.objectDefinitions) {
				if (objectDefinition is MXMLObjectDefinition) {
					contextXML.appendChild(serializeObjectDefinition(objectDefinition as MXMLObjectDefinition));
				} else if (objectDefinition is Template) {
					contextXML.appendChild(serializeTemplate(objectDefinition as Template));
				}
			}

			return contextXML;
		}

		public static function serializeObjectDefinition(objectDefinition:MXMLObjectDefinition, isAnonymous:Boolean = false):XML {
			var objectXML:XML;

			if (objectDefinition.template == null) {
				objectXML = <object class=""/>;
				objectXML.attribute("class")[0] = objectDefinition.className;
			} else {
				objectXML = <object/>;
				objectXML.@template = objectDefinition.template.id;
			}

			if (objectDefinition.parentObject != null) {
				objectXML.@parent = objectDefinition.parentObject.id;
			}

			if (objectDefinition.explicitProperties['factoryObjectName'] != null) {
				objectXML.attribute("factory-object")[0] = objectDefinition.factoryObjectName;
			}

			if (objectDefinition.explicitProperties['factoryMethod'] != null) {
				objectXML.attribute("factory-method")[0] = objectDefinition.factoryMethod;
			}

			if (objectDefinition.explicitProperties['initMethod'] != null) {
				objectXML.attribute("init-method")[0] = objectDefinition.initMethod;
			}

			if (objectDefinition.explicitProperties['scope'] != null) {
				objectXML.@scope = objectDefinition.scope;
			}

			if (objectDefinition.explicitProperties['isLazyInit'] != null) {
				objectXML.attribute("lazy-init")[0] = objectDefinition.isLazyInit.toString();
			}

			if (objectDefinition.explicitProperties['isAutoWireCandidate'] != null) {
				objectXML.attribute("autowire-candidate")[0] = objectDefinition.isAutoWireCandidate.toString();
			}

			if (objectDefinition.explicitProperties['autoWireMode'] != null) {
				objectXML.@autowire = objectDefinition.autoWireMode;
			}

			if (objectDefinition.explicitProperties['primary'] != null) {
				objectXML.@primary = objectDefinition.primary.toString();
			}

			if (objectDefinition.explicitProperties['skipPostProcessors'] != null) {
				objectXML.attribute("skip-postprocessors")[0] = objectDefinition.skipPostProcessors.toString();
			}

			if (objectDefinition.explicitProperties['skipMetadata'] != null) {
				objectXML.attribute("skip-metadata")[0] = objectDefinition.skipMetadata.toString();
			}

			if (!isAnonymous) {
				objectXML.@id = objectDefinition.id;
			}

			for (var name:String in objectDefinition.params) {
				objectXML.appendChild(serializeParam(name, objectDefinition.params[name]));
			}

			for each (var conArg:* in objectDefinition.constructorArguments) {
				objectXML.appendChild(serializeConstructorArg(conArg, objectDefinition));
			}

			for (var prop:String in objectDefinition.properties) {
				objectXML.appendChild(serializeProperty(prop, objectDefinition.properties[prop], objectDefinition));
			}

			for each (var method:MethodInvocation in objectDefinition.methodDefinitions) {
				objectXML.appendChild(serializeMethodInvocation(method, objectDefinition));
			}

			return objectXML;
		}

		public static function serializeTemplate(template:Template):XML {
			var templateXML:XML = <template/>;
			templateXML.@id = template.id;
			templateXML.appendChild(serializeObjectDefinition(template.objectDefinition, true));
			return templateXML;
		}

		public static function serializeParam(name:String, value:String):XML {
			var paramXML:XML = <param/>;
			paramXML.@name = name;
			paramXML.@value = value;
			return paramXML;
		}

		public static function serializeProperty(name:String, value:*, objectDefinition:MXMLObjectDefinition):XML {
			var propXML:XML = <property/>;
			propXML.@name = name;
			serializeValue(value, propXML, objectDefinition);
			return propXML;
		}

		public static function serializeMethodInvocation(method:MethodInvocation, objectDefinition:MXMLObjectDefinition):XML {
			var methodXML:XML = <method-invocation/>;
			methodXML.@name = method.methodName;

			for each (var arg:Arg in method.arguments) {
				methodXML.appendChild(serializeArg(arg, objectDefinition));
			}
			return methodXML;
		}

		public static function serializeArg(arg:Arg, objectDefinition:MXMLObjectDefinition):XML {
			var argXML:XML = <arg/>;
			serializeValue(arg.value, argXML, objectDefinition);
			return argXML;
		}

		public static function serializeConstructorArg(value:*, objectDefinition:MXMLObjectDefinition):XML {
			var constructorArgXML:XML = <constructor-arg/>;
			serializeValue(value, constructorArgXML, objectDefinition);
			return constructorArgXML;
		}

		public static function serializeValue(value:*, containerXML:XML, objectDefinition:MXMLObjectDefinition):void {
			var val:XML;

			if (value is RuntimeObjectReference) {
				val = <value/>;
				serializeRuntimeObjectReference((value as RuntimeObjectReference), val, objectDefinition);
				containerXML.appendChild(val);
			} else if (value is Array) {
				val = <value/>;
				val.appendChild(serializeArray((value as Array), <array/>, objectDefinition));
				containerXML.appendChild(val);
			} else if (value is ArrayCollection) {
				val = <value/>;
				val.appendChild(serializeArray((value as ArrayCollection).source, <array-collection/>, objectDefinition));
				containerXML.appendChild(val);
			}  /* else if (value is Vector) {
			   val = <value/>;
			   val.appendChild(serializeVector((value as Vector).source, <vector/>, objectDefinition));
			   containerXML.appendChild(val);
			 }*/else if (value is Dictionary) {
				val = <value/>;
				val.appendChild(serializeDictionary((value as Dictionary), objectDefinition));
				containerXML.appendChild(val);
			} else if (value is Class) {
				containerXML.@value = ClassUtils.getFullyQualifiedName((value as Class), true);
				containerXML.@type = "class";
			} else {
				containerXML.@value = value.toString();
			}
		}

		public static function serializeArray(array:Array, container:XML, objectDefinition:MXMLObjectDefinition):XML {
			array.forEach(function(item:*, index:int, arr:Array):void {
				var val:XML = <value/>;
				serializeValue(item, val, objectDefinition);

				if (val.@value.length() > 0) {
					val.setChildren(String(val.@value));
					delete val.@value;
				}
				container.appendChild(val);
			});
			return container;
		}

		/*public static function serializeVector(array:Array, container:XML, objectDefinition:MXMLObjectDefinition):XML {
		   array.forEach(function(item:*, index:int, arr:Array):void {
		   var val:XML = <value/>;
		   serializeValue(item, val, objectDefinition);

		   if (val.@value.length() > 0) {
		   val.setChildren(String(val.@value));
		   delete val.@value;
		   }
		   container.appendChild(val);
		   });
		   return container;
		 }*/

		public static function serializeDictionary(dictionary:Dictionary, objectDefinition:MXMLObjectDefinition):XML {
			var dictXML:XML = <dictionary/>;

			for (var prop:String in dictionary) {
				var entry:XML = <entry/>;
				entry.@key = prop;
				serializeValue(dictionary[prop], entry, objectDefinition);
				dictXML.appendChild(entry);
			}
			return dictXML;
		}

		public static function getObjectDefinitionByName(objectName:String, objectDefinitions:Array):MXMLObjectDefinition {
			var result:MXMLObjectDefinition = null;
			objectDefinitions.some(function(item:*, index:int, arr:Array):Boolean {
				var objDef:MXMLObjectDefinition = (item as MXMLObjectDefinition);

				if (objDef != null) {
					if (objDef.id == objectName) {
						result = objDef;
						return true;
					}
				}
				return false;
			});
			return result;
		}

		public static function serializeRuntimeObjectReference(runtimeObjectReference:RuntimeObjectReference, xmlObj:XML, objectDefinition:MXMLObjectDefinition):void {
			var refName:String = runtimeObjectReference.objectName;

			if (refName.indexOf(MXMLObjectDefinition.ANON_OBJECT_PREFIX) > -1) {
				var refDefinition:MXMLObjectDefinition = getObjectDefinitionByName(refName, objectDefinition.propertyObjectDefinitions);
				xmlObj.appendChild(serializeObjectDefinition(refDefinition, true));
			} else {
				xmlObj.@ref = refName;
			}
		}

	}
}