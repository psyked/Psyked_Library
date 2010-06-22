package com.gnstudio.nabiro.air.data
{
	
	/**
	 *
	 * GNstudio nabiro
	 * =====================================================================
	 * Copyright(c) 2009
	 * http://www.gnstudio.com
	 *
	 *
	 *
	 * This file is part of the nabiro flash platform framework
	 *
	 *
	 * nabiro is free software; you can redistribute it and/or modify
	 * it under the terms of the GNU Lesser General Public License as published by
	 * the Free Software Foundation; either version 3 of the License, or
	 * at your option) any later version.
	 *
	 * nabiro is distributed in the hope that it will be useful,
	 * but WITHOUT ANY WARRANTY; without even the implied warranty of
	 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	 * GNU General Public License for more details.
	 *
	 * You should have received a copy of the GNU Lesser General Public License
	 * along with Intelligere SCS; if not, write to the Free Software
	 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
	 * =====================================================================
	 *
	 *
	 *
	 *   @package  nabiro
	 *
	 *   @version  0.9
	 *   @idea maker 			Giorgio Natili <g.natili@gnstudio.com>
	 *   @author 					Giorgio Natili <g.natili@gnstudio.com>
	 *   @request maker 	Fabio Biondi <f.biondi@gnstudio.com>
	 *	 @fine tuning			Alessandro Ronchi <a.ronchi@gnstudio.com>
	 */
	
	import __AS3__.vec.Vector;
	
	import com.gnstudio.nabiro.air.data.events.DBEvent;
	import com.gnstudio.nabiro.air.data.model.Record;
	
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.errors.SQLError;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	import flash.xml.XMLNode;
	
	import mx.collections.ArrayCollection;

	public class DataBaseHandler extends SQLConnection{
		
		private static var _instance:DataBaseHandler;
		private static var _target:IEventDispatcher;
		private var _isOpening:Boolean;
		
		protected var xdata:XML;
		
		private static var _className:String = getQualifiedClassName(super);
		
		public function DataBaseHandler(){
			
			if (_instance != null && getQualifiedSuperclassName(this) != _className) throw new Error("This a singleton class!");
			
		}
		
		/**
		 * Method used to be sure that only an instance of the class will be created
		 * @param target IEventDispatcher
		 */ 
		public static function getInstance(tg:IEventDispatcher = null):DataBaseHandler{
						
			if(!_instance){
				
				_instance = new DataBaseHandler();				
				
			}
			
			if(tg){
				
				_target = tg;
				
			}
			
			return _instance;
			
		}
		
		/**
		 * Database configurator, it creates the db getting the name and the folder attributes
		 * from the XML file and overwrite the existing db if the overwrite is true
		 * @param data XMLNode
		 * @param overwrite Boolean
		 */ 
		public function configureDB(data:XMLNode, overwrite:Boolean = false):void{
			
			xdata = XML(data);
			
			var file:File;
			
			if(xdata.@folder.toXMLString() != ""){
				
				var folder:File = File.applicationStorageDirectory.resolvePath(xdata.@folder);
				
				if(!folder.exists){
				
					folder.createDirectory();
					
				}
				
				file = File.applicationStorageDirectory.resolvePath(xdata.@folder + "/" + xdata.@name + ".db");
				
			}else{
			
			 	file = File.applicationStorageDirectory.resolvePath( xdata.@name + ".db");
			 	
			}
			
			addEventListener(SQLEvent.OPEN, onSQLFileOpened);			
			addEventListener(SQLErrorEvent.ERROR, onSQLError);
			
			if(!file.exists  && overwrite == true ){
				
				this.openAsync(file);
				return;
								
			}else{				
				
				if(_target){
					
					_target.dispatchEvent(new DBEvent(DBEvent.ALERADY_EXISTS));
							
				}else{
							
					dispatchEvent(new DBEvent(DBEvent.ALERADY_EXISTS));
							
				}
				
				_isOpening = true;
				
				if(overwrite && file.exists){
			
					file.addEventListener(Event.COMPLETE, onSQLFileDeleted);
						
					if(file.exists){
						
						this.close()
						file.deleteFileAsync();
							
						// Database has been dropped
						if(_target){
						
							_target.dispatchEvent(new DBEvent(DBEvent.DROPPED));
								
						}else{
								
							dispatchEvent(new DBEvent(DBEvent.DROPPED));
								
						}
							
					}
							
			}else{
				
				this.open(file);
				
				
			}
				
			}
			
			
						
		}
		
		protected function onSQLFileDeleted(e:Event):void{
			
			e.target.removeEventListener(e.type, arguments.callee);
			
			openAsync(e.target);
							
		}
		
		protected function onSQLFileOpened (e:SQLEvent):void{
			
			e.target.removeEventListener(e.type, arguments.callee);
			
			if(_isOpening){
				
				if(_target){
						
					_target.dispatchEvent(new DBEvent(DBEvent.OPENED));
						
				}else{
						
					dispatchEvent(new DBEvent(DBEvent.OPENED));
						
				}
				
				_isOpening = false;
				
			}else{
			
				// Databas has been creted
				if(_target){
						
					_target.dispatchEvent(new DBEvent(DBEvent.CREATED));
						
				}else{
						
					dispatchEvent(new DBEvent(DBEvent.CREATED));
						
				}
					
				createTables(xdata.tables.table);
			
			}
			
		}
		
		protected function onSQLError (e:SQLErrorEvent):void{
			
			e.target.removeEventListener(e.type, arguments.callee);
			
			if(_target){
					
				_target.dispatchEvent(new DBEvent(DBEvent.FAILED));
					
			}else{
					
				dispatchEvent(new DBEvent(DBEvent.FAILED));
					
			}
		
		}


		public static function dbExists(fileName:String) : Boolean{
			
			var exists:Boolean;
			
			var file:File = File.applicationStorageDirectory.resolvePath(fileName);
				
			if(file.exists){
					
				exists = true;
					
			}else{
					
				exists = false;	
					
			}
				
			return exists;
		
		}
		
		public function insertMultipleData(t:String, records:Vector.<Record>, stopOnError:Boolean = false):void{
			
			var data:XMLList = xdata.tables.table.(@name == t);
			
			if(!data.length()){
				
				throw new Error("The provided table doesn't exist!");
				return;
				
			}
			
			var q:SQLQueue = new SQLQueue();
			
			for each(var record:Record in records){
			
				var query:SQLStatementHaware = new SQLStatementHaware();
				query.sqlConnection = _instance;
				query.text = 'INSERT INTO ' +  t + '(';
				
				var fileds:int = data.field.length();
				var count:int = 0;
				
				var item:XML;
				
				var primaryKeyCount:int = data.field.(@primaryKey == true).length();
				var limit:int = fileds - 1 - primaryKeyCount;
				
				for each(item in data.field){
									
					if(item.@primaryKey != "true"){
					
						query.text += item.@name;
					
						if(count < limit){
								
							query.text += ", ";
								
						}
												
						count++; 
						
					}
					
				}
				
				query.text += ") VALUES (";
				count = 0;
				
				for each(item in data.field){
					
					if(item.@primaryKey != "true"){
						
						query.text += "@" + item.@name;
					
						if(count < limit){
								
							query.text += ", ";
								
						}
												
						count++; 
					
					}
					
				}
				
				query.text += ")";				
				
				for each(item in data.field){
					
					try{
						
						if(item.@primaryKey != "true")query.parameters["@" + item.@name] = record[item.@name];
						
					}catch(e:Error){
						
						throw new Error(e.message);		
						
					}
			
				}
					
			
				q.addItem(query, stopOnError);
				
				
			}
			
			q.addEventListener(DBEvent.SUCCESS_QUERY, function(e:DBEvent):void{
				
				dispatchEvent(new SQLEvent(SQLEvent.RESULT));
				
			});
			
			q.execute();						
			
		}
		
		public function insertData(t:String, record:Record):void{
			
			var data:XMLList = xdata.tables.table.(@name == t);
			
			if(!data.length()){
				
				throw new Error("The provided table doesn't exist!");
				return;
				
			}
			
			var query:SQLStatementHaware = new SQLStatementHaware()
			query.sqlConnection = _instance;
			query.text = 'INSERT INTO ' +  t + '(';
			
			var fileds:int = data.field.length();
			var count:int = 0;
			
			var item:XML;
			
			var primaryKeyCount:int = data.field.(@primaryKey == true).length();
			var limit:int = fileds - 1 - primaryKeyCount;
			
			for each(item in data.field){
								
				if(item.@primaryKey != "true"){
				
					query.text += item.@name;
				
					if(count < limit){
							
						query.text += ", ";
							
					}
											
					count++; 
					
				}
				
			}
			
			query.text += ") VALUES (";
			count = 0;
			
			for each(item in data.field){
				
				if(item.@primaryKey != "true"){
					
					query.text += "@" + item.@name;
				
					if(count < limit){
							
						query.text += ", ";
							
					}
											
					count++; 
				
				}
				
			}
			
			query.text += ")";
			
			
			for each(item in data.field){
				
				try{
					
					if(item.@primaryKey != "true")query.parameters["@" + item.@name] = record[item.@name];
					
				}catch(e:Error){
					
					throw new Error(e.message);		
					
				}
			
			}
						
			try{
				
				var db:DBEvent = new DBEvent( DBEvent.INSERT_ATTEMPT, query );				
				
				if(_target){
						
					_target.dispatchEvent(db);
						
				}else{
						
					dispatchEvent(db);
						
				}
				
				// attempt initial execution
				query.addEventListener(SQLEvent.RESULT, hanldeQueryResult);
				query.event = DBEvent.INSERTED;
				
				query.execute();
				
			}catch (err:SQLError){
				
				var dberror:DBEvent = new DBEvent(DBEvent.FAILED, query)			
				
				if(_target){
					
					_target.dispatchEvent(dberror);
					
				}else{
					
					dispatchEvent(dberror);
					
				}
								
			}
			
		//	trace(flash.utils.describeType(this).accessor);
			
			
		}
		
		public function updateData(t:String, record:Record, conditionField:String, conditionValue:*):void{
			
			var data:XMLList = xdata.tables.table.(@name == t);
			
			if(!data.length()){
				
				throw new Error("The provided table doesn't exist!");
				return;
				
			}
						
			if(!data.field.(@name == conditionField).length()){
				
				throw new Error("The provided field doesn't exist!");
				return;
				
			}
			
			// TODO check the datatype of the value
			
			var query:SQLStatementHaware = new SQLStatementHaware()
			query.sqlConnection = _instance;
			query.text = 'UPDATE ' +  t + ' SET ';
			
			var fileds:int = data.field.length();
			var count:int = 0;
			
			var item:XML;
			
			var primaryKeyCount:int = data.field.(@primaryKey == true).length();
			var limit:int = fileds - 1 - primaryKeyCount;
			
			for each(item in data.field){
								
				if(item.@primaryKey != "true"){		
					
					query.text += item.@name + " = " + "@" + item.@name;	
									
					if(count < limit){
							
						query.text += ", ";
							
					}
											
					count++; 
					
				}
				
			}
			
			for each(item in data.field){
				
				try{
					
					if(item.@primaryKey != "true")query.parameters["@" + item.@name] = record[item.@name];
					
				}catch(e:Error){
					
					throw new Error(e.message);		
					
				}
			
			}
			
			query.text += " WHERE " + conditionField + " = " + conditionValue;

			try{
				
				var db:DBEvent = new DBEvent( DBEvent.UPDATE_ATTEMPT, query );				
				
				if(_target){
						
					_target.dispatchEvent(db);
						
				}else{
						
					dispatchEvent(db);
						
				}
				
				// attempt initial execution
				query.addEventListener(SQLEvent.RESULT, hanldeQueryResult);
				query.event = DBEvent.UPDATED;
				
				query.execute();
				
				
			}catch (err:SQLError){
								
				var dberror:DBEvent = new DBEvent(DBEvent.FAILED, query)			
				
				if(_target){
					
					_target.dispatchEvent(dberror);
					
				}else{
					
					dispatchEvent(dberror);
					
				}
				
			}
			
			// trace(query.text);			
			
		}
		
		public function deleteRecords(t:String, conditionField:String, conditionValue:*, condition:String, deleteAll:Boolean = false):void{
			
			var data:XMLList = xdata.tables.table.(@name == t);
			
			if(!data.length()){
				
				throw new Error("The provided table doesn't exist!");
				return;
				
			}
						
			if(!data.field.(@name == conditionField).length()){
				
				throw new Error("The provided field doesn't exist!");
				return;
				
			}
			
			var query:SQLStatementHaware = new SQLStatementHaware();
			query.sqlConnection = _instance;
			
			if(deleteAll == true){
				
				query.text = "DELETE * FROM " + t;
				
			}else{
				
				query.text = "DELETE FROM " + t;
				query.text += " WHERE " + conditionField + " " + condition + " " + conditionValue;
				
			}
		
			try{
				
				var db:DBEvent = new DBEvent( DBEvent.DELETE_ATTEMPT, query );				
				
				if(_target){
						
					_target.dispatchEvent(db);
						
				}else{
						
					dispatchEvent(db);
						
				}
				
				// attempt initial execution
				query.addEventListener(SQLEvent.RESULT, hanldeQueryResult);
				query.event = DBEvent.DELETED;
				
				query.execute();
				
			}catch (err:SQLError){
			
				var dberror:DBEvent = new DBEvent(DBEvent.FAILED, query)			
				
				if(_target){
					
					_target.dispatchEvent(dberror);
					
				}else{
					
					dispatchEvent(dberror);
					
				}
				
			}
			
			
		}
		
		public function customQuery(query:String):void{
			
			var custom_query:SQLStatementHaware = new SQLStatementHaware();
			custom_query.sqlConnection = _instance;
			custom_query.text = query;
			
			try{
				
				// attempt initial execution
				custom_query.addEventListener(SQLEvent.RESULT, hanldeQueryResult);
				custom_query.event = DBEvent.CUSTOM_QUERIED;
				
				custom_query.execute();
				
				var db:DBEvent = new DBEvent( DBEvent.CUSTOM_QUERY_ATTEMPT, custom_query );				
				
				if(_target){
						
					_target.dispatchEvent(db);
						
				}else{
						
					dispatchEvent(db);
						
				}
				
			}catch (err:SQLError){
				
				var dberror:DBEvent = new DBEvent( DBEvent.FAILED, custom_query );				
				
				if(_target){
					
					_target.dispatchEvent(dberror);
					
				}else{
					
					dispatchEvent(dberror);
					
				}
								
			}
			
		
		}
		
		public function selectRecords(t:String, field:String, conditionField:String = "", conditionValue:* = null, condition:String = "", getAll:Boolean = false):void {
			
			var data:XMLList = xdata.tables.table.(@name == t);
			
			if(!data.length()){
				
				throw new Error("The provided table doesn't exist!");
				return;
				
			}
						
			if(!data.field.(@name == conditionField).length() && !getAll){
				
				throw new Error("The provided field doesn't exist!");
				return;
				
			} 
			
			var selection_query:SQLStatementHaware = new SQLStatementHaware();
			selection_query.sqlConnection = _instance;
			
			if(getAll == true){
				
				selection_query.text = "SELECT * FROM " + t;
				
				if(conditionField.length > 0 && conditionValue != null && condition.length > 0){
					
					selection_query.text += " WHERE " + conditionField + " " + condition + " " + conditionValue;
					
				} 
			
				
			}else{
				
				selection_query.text = "SELECT " + field + " FROM " + t;
				selection_query.text += " WHERE " + conditionField + " " + condition + " " + conditionValue;
				
			}
			
			try{
				
				trace("\tPerforming query", selection_query.text)	
				
				var db:DBEvent = new DBEvent( DBEvent.RECOVERING_ATTEMPT, selection_query );				
				
				if(_target){
						
					_target.dispatchEvent(db);
						
				}else{
						
					dispatchEvent(db);
						
				}
				
				// attempt initial execution
				selection_query.addEventListener(SQLEvent.RESULT, hanldeQueryResult);
				selection_query.event = DBEvent.RECOVERED;
				
				selection_query.execute();
				
				
			}catch (err:SQLError){
				
				var dberror:DBEvent = new DBEvent( DBEvent.FAILED, selection_query );				
				
				if(_target){
					
					_target.dispatchEvent(dberror);
					
				}else{
					
					dispatchEvent(dberror);
					
				}
								
			}
			
			
						
		}
		
		protected function hanldeQueryResult(e:SQLEvent):void{
						
			e.target.removeEventListener(e.type, arguments.callee);
			
			var db:DBEvent;
			
			var queryResult:SQLResult = e.target.getResult() as SQLResult;
			var collection:ArrayCollection;
			
			if(queryResult){
				
				collection = new ArrayCollection(queryResult.data);
				
			}else{
				
				collection = new ArrayCollection();
				
			}
			
			try{
				
				db = new DBEvent( e.target.event, e.target as SQLStatement, collection);	
				
			}catch(error:Error){
				
				trace("\t\tPROBLEM:", e.target.text, "REASON:", error.message)
				db = new DBEvent(DBEvent.FAILED, e.target as SQLStatement);		
				
				if(_target){
					
					_target.dispatchEvent(db);
					
				}else{
					
					dispatchEvent(db);
					
				}	
				
				return;
				
			}	
				
			if(_target){
					
				_target.dispatchEvent(db);
					
			}else{
					
				dispatchEvent(db);
					
			}
			
		}
		
		protected function createTables(data:XMLList):void{
			
			var queries:Array = [];
			
			var query:SQLStatement = new SQLStatement()
			query.sqlConnection = _instance;
			
			for each(var item:XML in data){
			
				var sqlString:String = "";
				sqlString += "CREATE TABLE '" + item.@name + "' ";
				
				if(item.field.length() > 0){
					
					sqlString += "(";
					
				}
				
				var fileds:int = item.field.length();
				var count:int = 0;
				 
				for each (var field:XML in item.field){
					
					sqlString += field.@name + " ";
					
					sqlString += field.@type + " ";
					
					if(field.@defaultValue.toXMLString().length > 0){
						
						sqlString += "DEFAULT " + field.@defaultValue.toXMLString() + " ";
						
					}
					
					if(field.@primaryKey == "true"){
						
						sqlString += "PRIMARY KEY ";
						
					}
					
					if(field.@notNull == "true"){
						
						sqlString += "NOT NULL ";
						
					}
					
				 	if(count < fileds - 1){
						
						sqlString += ", ";
						
					}
					
					
					
					count++; 
					
					// TODO use also this parameters
				//	trace(field.@isUnique)
				//	trace(field.@autoIncrement)
				
					
				}
				
				sqlString += ");";
					
				queries.push(sqlString);
			
				
			}	
			
			query.addEventListener(SQLEvent.RESULT, function(e:SQLEvent):void{				
				trace(queries.concat('--'))
				try{
					
					queries.splice(0, 1);
					
					query.text = queries[0];
					query.execute();
					
					if(_target){
					
						_target.dispatchEvent(new DBEvent(DBEvent.TABLE_CREATED, query));
					
					}else{
					
						dispatchEvent(new DBEvent(DBEvent.TABLE_CREATED, query));
					
					}
					
				}catch(error:Error){
					
					// Database tables creation is completed
					if(_target){
					
						_target.dispatchEvent(new DBEvent(DBEvent.CREATION_COMPLETED));
					
					}else{
					
						dispatchEvent(new DBEvent(DBEvent.CREATION_COMPLETED));
					
					}
					
				}
				
			});
			
			query.text = queries[0];
						
			var dbe:DBEvent;
			
			try{
				
				// Database table has been added
				query.execute();				
				dbe = new DBEvent(DBEvent.TABLE_CREATED, query);	
				
			}catch(error:Error){
				
				dbe = new DBEvent(DBEvent.FAILED);	
				
			}			
				
			if(_target){
					
				_target.dispatchEvent(dbe);
					
			}else{
					
				dispatchEvent(dbe);
					
			}
						
		}
		
	}
}