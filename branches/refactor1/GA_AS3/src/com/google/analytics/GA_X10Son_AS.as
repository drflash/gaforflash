/*
 * Copyright 2008 Adobe Systems Inc., 2008 Google Inc.Licensed under the Apache License, 
 * Version 2.0 (the "License");you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at    
 * http://www.apache.org/licenses/LICENSE-2.0Unless required by applicable law or agreed to in writing, 
 * software distributed under the License is distributed on an 
 * "AS IS" BASIS,WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
 * either express or implied.See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.google.analytics
{
	public class GA_X10Son_AS
	{
		  // ---------------------------------------------------------------------------
		  // PRIVATE VARIABLES
		  // ---------------------------------------------------------------------------
		  //private var selfRef = this;
		  private var nsCache:GA_utils_AS = GA_utils_AS.getGAUTIS();
		
		  private var projectData:Object = {};
		
		  // Type qualifiers for each of the types.
		  private const keyType:String = 'k';
		  private const valueType:String = 'v';
		  private var typeSet:Array = [keyType, valueType];
		
		  // Delimiters for wrapping a set of values belonging to the same type.
		  private const typeDelimBegin:String = '(';
		  private const typeDelimEnd:String = ')';
		
		  // Delimiter between two consecutive num/value pairs.
		  private const setDelim:String = '*';
		
		  // Delimiter between a num and its corresponding value.
		  private const numValueDelim :String = '!';
		
		  // Escape character. We're only escaping ), ,(comma), and :, but
		  // we'll need an escape character as well, which we've chosen to be ~.
		  private const escapeChar:String = "'";
		
		  // Mapping of escapable characters to their escaped forms.
		  private var escapeCharMap:Object = {};
		
		
		
		  // Assumed minimum number for the enum optimization within num/value pairs.
		  private  var minimumNum:Number = 1;
		  
		/**
		 * @class Google Analytics Tracker Code (GATC)'s extensible data component.
		 *     This class encapsulates all logic for setting and clearing extensible
		 *     data and generating the resultant URL parameter.
		 *
		 * @private
		 * @constructor
		 */
		public function GA_X10Son_AS()
		{
			  escapeCharMap[escapeChar] = "'0";
			  escapeCharMap[typeDelimEnd] = "'1";
			  escapeCharMap[setDelim] = "'2";
			  escapeCharMap[numValueDelim] = "'3";
		}
		
		  // ---------------------------------------------------------------------------
		  // PRIVATE METHODS
		  // ---------------------------------------------------------------------------
		  /**
		   * Internal implementation for setting an X10 data type.
		   *
		   * @private
		   * @param {Number} projectId The project ID for which to set a value.
		   * @param {String} type The data type for which to set a value.
		   * @param {Number} num The numeric index for which to set a value.
		   * @param {String} value The value to be set into the specified indices.
		   */
		  public function setInternal_(projectId:Number, type:String, num:Number, value:String):void 
		  {
		    if (nsCache.undef_ == projectData[projectId]) 
		    {
		      projectData[projectId] = {};
		    }
		    if (nsCache.undef_ == projectData[projectId][type]) 
		    {
		      projectData[projectId][type] = [];
		    }
		    projectData[projectId][type][num] = value;
		  }
		  
		  
		  /**
		   * Internal implementation for getting an X10 data type.
		   *
		   * @private
		   * @param {Number} projectId The project ID for which to set a value.
		   * @param {String} type The data type for which to set a value.
		   * @param {Number} num The numeric index for which to set a value.
		   *
		   * @return {Object} The stored object at the specified indices.
		   *     The value property of this object is the stored value, and
		   *     the optional aggregationType property of this object is
		   *     the specified custom aggregation type, if any.
		   */
		  public function getInternal_(projectId:Number, type:String, num:Number):Object
		  {
		    if (nsCache.undef_ != projectData[projectId] &&
		        nsCache.undef_ != projectData[projectId][type]) 
		    {
		      return projectData[projectId][type][num];
		    }
		    else 
		    {
		      return nsCache.undef_;
		    }
		  }
		  
		  
		  
		  /**
		   * Internal implementation for clearing all X10 data of a type
		   * from a certain project.
		   *
		   * @private
		   * @param {Number} projectId The project ID for which to set a value.
		   * @param {String} type The data type for which to set a value.
		   */
		 public function clearInternal_(projectId:Number, type:String):void 
		 {
		    if (nsCache.undef_ != projectData[projectId] &&
		        nsCache.undef_ != projectData[projectId][type]) 
		    {
			      projectData[projectId][type] = nsCache.undef_;
			
			      var isEmpty:Boolean = true;
			      var i:Number;
			      for (i = 0; i < typeSet.length; i++) 
			      {
			        if (nsCache.undef_ != projectData[projectId][typeSet[i]]) 
			        {
			          isEmpty = false;
			          break;
			        }
			      }
			      if (isEmpty)
			      {
			        projectData[projectId] = nsCache.undef_;
			      }
			 }
		  }
		  
		  
		  /**
		   * Given a project hashmap, render its string encoding.
		   *
		   * @private
		   * @param {Object} project A hashmap of project data keyed by data type.
		   *
		   * @return {String} The string encoding for this project.
		   */
		  public function renderProject_(project:Object):String
		  {
		    var result:String = '';
		
		    // Do we need to output the type string? As an optimization we do not
		    // output the type string if it's the first type, or if the previous
		    // type was present.
		    var needTypeQualifier:Boolean = false;
		    var i:Number;
		    var dataType:Array;
		    for (i = 0; i < typeSet.length; i++) 
		    {
		      dataType = project[typeSet[i]];
		
		      if (nsCache.undef_ != dataType) 
		      {
		        if (needTypeQualifier) 
		        {
		          result += typeSet[i];
		        }
		        result += renderDataType_(dataType);
		        needTypeQualifier = false;
		      } 
		      else 
		      {
		        needTypeQualifier = true;
		      }
		    }
		    return result;
		  }
		  
		  
		  /**
		   * Given a data array for a certain type, render its string encoding.
		   *
		   * @private
		   * @param {Array} dataType An array of num/value pair data.
		   *
		   * @return {String} The string encoding for this array of data.
		   */
		  public function renderDataType_(dataType:Array) :String
		  {
		    var resultArray:Array = [];
		    var result:String;
		    var i:Number;
		
		    // Technically arrays start at 0, but X10 numeric indices start at 1.
		    for (i = 0; i < dataType.length; i++) 
		    {
		      if (nsCache.undef_ != dataType[i]) 
		      {
		        result = '';
		
		        // Check if we need to append the number. If the last number was
		        // outputted, or if this is the assumed minimum, then we don't.
		        if (i != minimumNum && nsCache.undef_ == dataType[i - 1]) 
		        {
		          result += i.toString();
		          result += numValueDelim;
		        }
		        result += escapeExtensibleValue_(dataType[i]);
		        nsCache.arrayPush_(resultArray, result);
		      }
		    }
		    // Wrap things up.
		    return typeDelimBegin + resultArray.join(setDelim) + typeDelimEnd;
		  }
		  
		   
		  /**
		   * Escape X10 string values to remove ambiguity for special characters.
		   * See the escapeCharMap public member for more detail.
		   *
		   * @private
		   * @param {String} value The string value to be escaped.
		   *
		   * @return {String} The escaped version of the passed-in value.
		   */
		 public function escapeExtensibleValue_(value:String):String
		 {
		    var result:String = '';
		    var i:Number;
		    var c:String, escaped:String;
		
		    for (i = 0; i < value[nsCache.LENGTH_]; i++) 
		    {
		      c = value.charAt(i);
		      escaped = escapeCharMap[c];
		
		      if (nsCache.undef_ != escaped) 
		      {
		        result += escaped;
		      } 
		      else 
		      {
		        result += c;
		      }
		    }
		    return result;
		  }
		  
		  
		  // ---------------------------------------------------------------------------
		  // PRIVILIGED METHODS
		  // ---------------------------------------------------------------------------
		  /**
		   * Checking whether a project exists in the current data state.
		   *
		   * @private
		   * @param {Number} projectId The identifier for the project.
		   *
		   * @return {Boolean} whether this X10 module contains the project at
		   *     the designated project ID.
		   */
		  public function hasProject_(projectId:Number) :Boolean
		  {
		    return nsCache.undef_ != projectData[projectId];
		  };

		  /**
		   * Generates the URL parameter string for the current internal extensible
		   * data state.
		   *
		   * @private
		   * @return {String} Encoded extensible data string.
		   */
		  public function  renderUrlString_ ():String 
		  {
		    var resultArray:Array = []; 
		    var projectId:String;
		    for (projectId in projectData) 
		    {
		      if (nsCache.undef_ != projectData[projectId]) 
		      {
		        nsCache.arrayPush_(
		            resultArray,
		            projectId.toString() + renderProject_(projectData[projectId]));
		      }
		    }
		    return resultArray.join("");
		  }

		  /**
		   * Generates the URL parameter string for the current internal extensible
		   * data state, merging in the internal data state of an auxiliary X10 object.
		   *
		   * @private
		   * @param {_gat.GA_X10_} opt_extObject  Optional parameter.  X10 object that
		   *     will be used for merging with this X10 object.  If this parameter is
		   *     omitted, then this method will return the URL string for only this X10
		   *     object.
		   *
		   * @return {String} Encoded extensible data string including the data for
		   *     opt_extObject and the data for this object. If project data for the
		   *     same project id is found in both opt_extObject and this object, then we
		   *     will only render the data in opt_extObject.
		   */
		  public function renderMergedUrlString_(opt_extObject:GA_X10Son_AS = null):String 
		  {
		    if (opt_extObject ==  null) 
		    {
		      return renderUrlString_();
		    }
		    var resultArray :Array= [opt_extObject.renderUrlString_()];
		    var projectId:String;
		    for (projectId in projectData) 
		    {
		      if (nsCache.undef_ != projectData[projectId] &&
		          !opt_extObject.hasProject_(Number(projectId))) 
		      {
		        nsCache.arrayPush_(
		          resultArray,
		          projectId.toString() + renderProject_(projectData[projectId]));
		      }
		    }
		    return resultArray.join("");
		  }

		  /**
		   * Wrapper for setting an X10 string key.
		   *
		   * @private
		   * @param {Number} projectId The project ID for which to set a value.
		   * @param {Number} num The numeric index for which to set a value.
		   * @param {String} value The value to be set into the specified indices.
		   *
		   * @return {Boolean} Whether the key was successfully set.
		   */
		  public function _setKey (projectId:Number, num:Number, value:String):Boolean 
		  {
		  	/*
		    if (typeof value != 'string') 
		    {
		      return false;
		    }*/  
		    // type checking will be done in action script
		    
		    setInternal_(projectId, keyType, num, value);
		    return true;
		  };

		  /**
		   * Wrapper for setting an X10 integer value.
		   *
		   * @private
		   * @param {Number} projectId The project ID for which to set a value.
		   * @param {Number} num The numeric index for which to set a value.
		   * @param {String} value The value to be set into the specified indices.
		   *
		   * @return {Boolean} whether the value was successfully set.
		   */
		  public function _setValue(projectId:Number, num:Number, value:Number):Boolean
		  {
			  	/*
			    if (typeof value != 'number'
			        && (nsCache.undef_ == Number
			            || !(value instanceof Number))) {
			      return false;
			    }*/
			    
			     // type checking will be done in action script
			     
			     
			   // if (Math.round(value) != value || value == NaN || value == Infinity) 
			   if(Math.round(value) != value)
			    {
			      return false;
			    }
			    setInternal_(projectId,
			                 valueType,
			                 num,
			                 value.toString());
			    return true;
		  }

		  /**
		   * Wrapper for getting an X10 string key.
		   *
		   * @private
		   * @param {Number} projectId The project ID for which to get a value.
		   * @param {Number} num The numeric index for which to get a value.
		   *
		   * @return {String} The requested key, null if not found.
		   */
		  public function _getKey(projectId:Number, num:Number) :Object
		  {
		    return getInternal_(projectId, keyType, num);
		  };

		  /**
		   * Wrapper for getting an X10 integer value.
		   *
		   * @private
		   * @param {Number} projectId The project ID for which to get a value.
		   * @param {Number} num The numeric index for which to get a value.
		   *
		   * @return {String} The requested value in string form, null if not found.
		   */
		  public function _getValue(projectId:Number, num:Number) :Object
		  {
		    return getInternal_(projectId, valueType, num);
		  };

		  /**
		   * Wrapper for clearing all X10 string keys for a given project ID.
		   *
		   * @private
		   * @param {Number} projectId The project ID for which to clear all keys.
		   */
		  public function _clearKey(projectId:Number):void 
		  {
		    clearInternal_(projectId, keyType);
		  }

		  /**
		   * Wrapper for clearing all X10 integer values for a given project ID.
		   *
		   * @private
		   * @param {Number} projectId The project ID for which to clear all values.
		   */
		  public function _clearValue(projectId:Number) :void
		  {
		    clearInternal_(projectId, valueType);
		  }

	}
}

 