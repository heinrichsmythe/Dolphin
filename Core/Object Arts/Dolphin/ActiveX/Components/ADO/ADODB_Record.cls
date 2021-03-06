﻿"Filed out from Dolphin Smalltalk 7"!

ADODB_ADO subclass: #ADODB_Record
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'ADODBConstants'
	classInstanceVariableNames: ''!
ADODB_Record guid: (IID fromString: '{00000562-0000-0010-8000-00AA006D2EA4}')!
ADODB_Record comment: '<ADODB_Record> is a wrapper class for the COM interface ''ADODB._Record'' generated from type information in the ''Microsoft ActiveX Data Objects 2.5 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!ADODB_Record categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODB_Record methodsFor!

activeConnection
	"Answer the <variant> value of the 'ActiveConnection' property of the receiver."

	| answer |
	answer := VARIANT new.
	self get_ActiveConnection: answer.
	^answer asObject
!

activeConnection: pvar
	"Set the 'ActiveConnection' property of the receiver to the <bstr> value of the argument."

	self put_ActiveConnection: pvar
!

Cancel
	"Invoke the Cancel() method of the COM object.

		HRESULT __stdcall Cancel();"

	<virtual stdcall: hresult 27>
	^self invalidCall
!

Close
	"Invoke the Close() method of the COM object.

		HRESULT __stdcall Close();"

	<virtual stdcall: hresult 23>
	^self invalidCall
!

copyRecord
	"Answer the <BSTR> result of invoking the CopyRecord() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 copyRecord: ''
		 destination: ''
		 userName: nil
		 password: nil
		 options: -1
		 async: nil!

copyRecord: source destination: destination userName: userName password: password options: options async: async
	"Answer the <BSTR> result of invoking the CopyRecord() method of the COM object."

	| answer |
	answer := BSTR new.
	self
		CopyRecord: source
		Destination: destination
		UserName: userName
		Password: password
		Options: options
		Async: async
		pbstrNewURL: answer.
	^answer asObject
!

CopyRecord: source Destination: destination UserName: userName Password: password Options: options Async: async pbstrNewURL: pbstrNewURL
	"Private - Invoke the CopyRecord() method of the COM object.

		HRESULT __stdcall CopyRecord(
			[in, optional, defaultvalue("")] BSTR Source,
			[in, optional, defaultvalue("")] BSTR Destination,
			[in, optional] BSTR UserName,
			[in, optional] BSTR Password,
			[in, optional, defaultvalue(-1)] CopyRecordOptionsEnum Options,
			[in, optional] VARIANT_BOOL Async,
			[out, retval] BSTR* pbstrNewURL);"

	<virtual stdcall: hresult 20 bstr bstr bstr bstr sdword varbool bstr*>
	^self invalidCall
!

deleteRecord
	"Invoke the DeleteRecord() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 DeleteRecord: nil
		 Async: nil!

DeleteRecord: source Async: async
	"Invoke the DeleteRecord() method of the COM object.

		HRESULT __stdcall DeleteRecord(
			[in, optional] BSTR Source,
			[in, optional] VARIANT_BOOL Async);"

	<virtual stdcall: hresult 21 bstr varbool>
	^self invalidCall
!

fields
	"Answer the <ADODBFields> value of the 'Fields' property of the receiver.
	Implementation Note: Originally auto-generated from the ADO type library,
	this method has been modified to answer a Smalltalk <sequencedReadableCollection>."

	| answer |
	answer := ADODBFields newPointer.
	self get_Fields: answer.
	^ADOCollection on: answer!

get_ActiveConnection: pvar
	"Private - Get the value of the 'ActiveConnection' property of the receiver.
				HRESULT __stdcall ActiveConnection(
			[out, retval] VARIANT* pvar);"

	<virtual stdcall: hresult 9 variant*>
	^self invalidCall
!

get_Fields: ppFlds
	"Private - Get the value of the 'Fields' property of the receiver.
				HRESULT __stdcall Fields(
			[out, retval] Fields** ppFlds);"

	<virtual stdcall: hresult 24 ADODBFields**>
	^self invalidCall
!

get_Mode: pMode
	"Private - Get the value of the 'Mode' property of the receiver.
				HRESULT __stdcall Mode(
			[out, retval] ConnectModeEnum* pMode);"

	<virtual stdcall: hresult 16 sdword*>
	^self invalidCall
!

get_ParentURL: pbstrParentURL
	"Private - Get the value of the 'ParentURL' property of the receiver.
				HRESULT __stdcall ParentURL(
			[out, retval] BSTR* pbstrParentURL);"

	<virtual stdcall: hresult 18 bstr*>
	^self invalidCall
!

get_RecordType: ptype
	"Private - Get the value of the 'RecordType' property of the receiver.
				HRESULT __stdcall RecordType(
			[out, retval] RecordTypeEnum* ptype);"

	<virtual stdcall: hresult 25 sdword*>
	^self invalidCall
!

get_Source: pvar
	"Private - Get the value of the 'Source' property of the receiver.
				HRESULT __stdcall Source(
			[out, retval] VARIANT* pvar);"

	<virtual stdcall: hresult 13 variant*>
	^self invalidCall
!

get_State: pState
	"Private - Get the value of the 'State' property of the receiver.
				HRESULT __stdcall State(
			[out, retval] ObjectStateEnum* pState);"

	<virtual stdcall: hresult 12 sdword*>
	^self invalidCall
!

getChildren
	"Answer the <ADODB_Recordset> result of invoking the GetChildren() method of the COM object."

	| answer |
	answer := ADODB_Recordset newPointer.
	self GetChildren: answer.
	^answer asObject
!

GetChildren: pprset
	"Private - Invoke the GetChildren() method of the COM object.

		HRESULT __stdcall GetChildren(
			[out, retval] _Recordset** pprset);"

	<virtual stdcall: hresult 26 ADODB_Recordset**>
	^self invalidCall
!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^true!

isVBCollection
	"Answer whether the receiver is a VB style collection.
	The receiver is dynamically extensible, so we cannot determine this from the
	type library, and must perform a run-time check for the _NewEnum property."

	^self has_NewEnum!

mode
	"Answer the <sdword> value of the 'Mode' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_Mode: answer.
	^answer asObject
!

mode: pMode
	"Set the 'Mode' property of the receiver to the <sdword> value of the argument."

	self put_Mode: pMode
!

moveRecord
	"Answer the <BSTR> result of invoking the MoveRecord() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 moveRecord: ''
		 destination: ''
		 userName: nil
		 password: nil
		 options: -1
		 async: nil!

moveRecord: source destination: destination userName: userName password: password options: options async: async
	"Answer the <BSTR> result of invoking the MoveRecord() method of the COM object."

	| answer |
	answer := BSTR new.
	self
		MoveRecord: source
		Destination: destination
		UserName: userName
		Password: password
		Options: options
		Async: async
		pbstrNewURL: answer.
	^answer asObject
!

MoveRecord: source Destination: destination UserName: userName Password: password Options: options Async: async pbstrNewURL: pbstrNewURL
	"Private - Invoke the MoveRecord() method of the COM object.

		HRESULT __stdcall MoveRecord(
			[in, optional, defaultvalue("")] BSTR Source,
			[in, optional, defaultvalue("")] BSTR Destination,
			[in, optional] BSTR UserName,
			[in, optional] BSTR Password,
			[in, optional, defaultvalue(-1)] MoveRecordOptionsEnum Options,
			[in, optional] VARIANT_BOOL Async,
			[out, retval] BSTR* pbstrNewURL);"

	<virtual stdcall: hresult 19 bstr bstr bstr bstr sdword varbool bstr*>
	^self invalidCall
!

open
	"Invoke the Open() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 open: VARIANT unspecified
		 activeConnection: VARIANT unspecified
		 mode: nil
		 createOptions: -1
		 options: -1
		 userName: nil
		 password: nil!

open: source activeConnection: activeConnection mode: mode createOptions: createOptions options: options userName: userName password: password
	"Invoke the Open() method of the COM object."

	^self
		Open: source asVariant
		ActiveConnection: activeConnection asVariant
		Mode: mode
		CreateOptions: createOptions
		Options: options
		UserName: userName
		Password: password
!

Open: source ActiveConnection: activeConnection Mode: mode CreateOptions: createOptions Options: options UserName: userName Password: password
	"Private - Invoke the Open() method of the COM object.

		HRESULT __stdcall Open(
			[in, optional] VARIANT Source,
			[in, optional] VARIANT ActiveConnection,
			[in, optional] ConnectModeEnum Mode,
			[in, optional, defaultvalue(-1)] RecordCreateOptionsEnum CreateOptions,
			[in, optional, defaultvalue(-1)] RecordOpenOptionsEnum Options,
			[in, optional] BSTR UserName,
			[in, optional] BSTR Password);"

	<virtual stdcall: hresult 22 variant variant sdword sdword sdword bstr bstr>
	^self invalidCall
!

parentURL
	"Answer the <bstr> value of the 'ParentURL' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_ParentURL: answer.
	^answer asObject
!

put_ActiveConnection: pvar
	"Private - Set the value of the 'ActiveConnection' property of the object wrapped by the 
	 receiver to the <bstr> argument, pvar.
				HRESULT __stdcall ActiveConnection(
			[in] BSTR pvar);"

	<virtual stdcall: hresult 10 bstr>
	^self invalidCall
!

put_Mode: pMode
	"Private - Set the value of the 'Mode' property of the object wrapped by the 
	 receiver to the <sdword> argument, pMode.
				HRESULT __stdcall Mode(
			[in] ConnectModeEnum pMode);"

	<virtual stdcall: hresult 17 sdword>
	^self invalidCall
!

put_Source: pvar
	"Private - Set the value of the 'Source' property of the object wrapped by the 
	 receiver to the <bstr> argument, pvar.
				HRESULT __stdcall Source(
			[in] BSTR pvar);"

	<virtual stdcall: hresult 14 bstr>
	^self invalidCall
!

putref_ActiveConnection: pvar
	"Private - Set the value of the 'ActiveConnection' property of the object wrapped by the 
	 receiver to the <ADODB_Connection*> argument, pvar.
				HRESULT __stdcall ActiveConnection(
			[in] _Connection* pvar);"

	<virtual stdcall: hresult 11 ADODB_Connection*>
	^self invalidCall
!

putref_Source: pvar
	"Private - Set the value of the 'Source' property of the object wrapped by the 
	 receiver to the <IDispatch*> argument, pvar.
				HRESULT __stdcall Source(
			[in] IDispatch* pvar);"

	<virtual stdcall: hresult 15 IDispatch*>
	^self invalidCall
!

recordType
	"Answer the <sdword> value of the 'RecordType' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_RecordType: answer.
	^answer asObject
!

setActiveConnection: pvar
	"Set the 'ActiveConnection' property of the receiver to the <ADODB_Connection*> value of the argument."

	self putref_ActiveConnection: pvar
!

setSource: pvar
	"Set the 'Source' property of the receiver to the <IDispatch*> value of the argument."

	self putref_Source: pvar
!

source
	"Answer the <variant> value of the 'Source' property of the receiver."

	| answer |
	answer := VARIANT new.
	self get_Source: answer.
	^answer asObject
!

source: pvar
	"Set the 'Source' property of the receiver to the <bstr> value of the argument."

	self put_Source: pvar
!

state
	"Answer the <sdword> value of the 'State' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_State: answer.
	^answer asObject
!

value
	"Answer the <ADODBFields> value of the 'Fields' property of the receiver.
	This is the default value (DISPID_VALUE) property of the receiver."

	^self fields
! !
!ADODB_Record categoriesFor: #activeConnection!**auto generated**!properties!public! !
!ADODB_Record categoriesFor: #activeConnection:!**auto generated**!properties!public! !
!ADODB_Record categoriesFor: #Cancel!**auto generated**!COM Interfaces-_Record!public! !
!ADODB_Record categoriesFor: #Close!**auto generated**!COM Interfaces-_Record!public! !
!ADODB_Record categoriesFor: #copyRecord!**auto generated**!methods!public! !
!ADODB_Record categoriesFor: #copyRecord:destination:userName:password:options:async:!**auto generated**!methods!public! !
!ADODB_Record categoriesFor: #CopyRecord:Destination:UserName:Password:Options:Async:pbstrNewURL:!**auto generated**!COM Interfaces-_Record!private! !
!ADODB_Record categoriesFor: #deleteRecord!**auto generated**!methods!public! !
!ADODB_Record categoriesFor: #DeleteRecord:Async:!**auto generated**!COM Interfaces-_Record!public! !
!ADODB_Record categoriesFor: #fields!properties!public! !
!ADODB_Record categoriesFor: #get_ActiveConnection:!**auto generated**!COM Interfaces-_Record!private! !
!ADODB_Record categoriesFor: #get_Fields:!**auto generated**!COM Interfaces-_Record!private! !
!ADODB_Record categoriesFor: #get_Mode:!**auto generated**!COM Interfaces-_Record!private! !
!ADODB_Record categoriesFor: #get_ParentURL:!**auto generated**!COM Interfaces-_Record!private! !
!ADODB_Record categoriesFor: #get_RecordType:!**auto generated**!COM Interfaces-_Record!private! !
!ADODB_Record categoriesFor: #get_Source:!**auto generated**!COM Interfaces-_Record!private! !
!ADODB_Record categoriesFor: #get_State:!**auto generated**!COM Interfaces-_Record!private! !
!ADODB_Record categoriesFor: #getChildren!**auto generated**!methods!public! !
!ADODB_Record categoriesFor: #GetChildren:!**auto generated**!COM Interfaces-_Record!private! !
!ADODB_Record categoriesFor: #isExtensible!**auto generated**!public!testing! !
!ADODB_Record categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!ADODB_Record categoriesFor: #mode!**auto generated**!properties!public! !
!ADODB_Record categoriesFor: #mode:!**auto generated**!properties!public! !
!ADODB_Record categoriesFor: #moveRecord!**auto generated**!methods!public! !
!ADODB_Record categoriesFor: #moveRecord:destination:userName:password:options:async:!**auto generated**!methods!public! !
!ADODB_Record categoriesFor: #MoveRecord:Destination:UserName:Password:Options:Async:pbstrNewURL:!**auto generated**!COM Interfaces-_Record!private! !
!ADODB_Record categoriesFor: #open!**auto generated**!methods!public! !
!ADODB_Record categoriesFor: #open:activeConnection:mode:createOptions:options:userName:password:!**auto generated**!methods!public! !
!ADODB_Record categoriesFor: #Open:ActiveConnection:Mode:CreateOptions:Options:UserName:Password:!**auto generated**!COM Interfaces-_Record!private! !
!ADODB_Record categoriesFor: #parentURL!**auto generated**!properties!public! !
!ADODB_Record categoriesFor: #put_ActiveConnection:!**auto generated**!COM Interfaces-_Record!private! !
!ADODB_Record categoriesFor: #put_Mode:!**auto generated**!COM Interfaces-_Record!private! !
!ADODB_Record categoriesFor: #put_Source:!**auto generated**!COM Interfaces-_Record!private! !
!ADODB_Record categoriesFor: #putref_ActiveConnection:!**auto generated**!COM Interfaces-_Record!private! !
!ADODB_Record categoriesFor: #putref_Source:!**auto generated**!COM Interfaces-_Record!private! !
!ADODB_Record categoriesFor: #recordType!**auto generated**!properties!public! !
!ADODB_Record categoriesFor: #setActiveConnection:!**auto generated**!properties!public! !
!ADODB_Record categoriesFor: #setSource:!**auto generated**!properties!public! !
!ADODB_Record categoriesFor: #source!**auto generated**!properties!public! !
!ADODB_Record categoriesFor: #source:!**auto generated**!properties!public! !
!ADODB_Record categoriesFor: #state!**auto generated**!properties!public! !
!ADODB_Record categoriesFor: #value!**auto generated**!properties!public! !

!ADODB_Record class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (Record) for which the receiver is the default interface."

	^CLSID fromString: '{00000560-0000-0010-8000-00AA006D2EA4}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB._Record'
		ADODB_Record defineTemplate"

	self
		defineFunction: #get_ActiveConnection:
			argumentTypes: 'variant*';
		defineFunction: #put_ActiveConnection:
			argumentTypes: 'bstr';
		defineFunction: #putref_ActiveConnection:
			argumentTypes: 'ADODB_Connection*';
		defineFunction: #get_State:
			argumentTypes: 'sdword*';
		defineFunction: #get_Source:
			argumentTypes: 'variant*';
		defineFunction: #put_Source:
			argumentTypes: 'bstr';
		defineFunction: #putref_Source:
			argumentTypes: 'IDispatch*';
		defineFunction: #get_Mode:
			argumentTypes: 'sdword*';
		defineFunction: #put_Mode:
			argumentTypes: 'sdword';
		defineFunction: #get_ParentURL:
			argumentTypes: 'bstr*';
		defineFunction: #MoveRecord:Destination:UserName:Password:Options:Async:pbstrNewURL:
			argumentTypes: 'bstr bstr bstr bstr sdword varbool bstr*';
		defineFunction: #CopyRecord:Destination:UserName:Password:Options:Async:pbstrNewURL:
			argumentTypes: 'bstr bstr bstr bstr sdword varbool bstr*';
		defineFunction: #DeleteRecord:Async:
			argumentTypes: 'bstr varbool';
		defineFunction: #Open:ActiveConnection:Mode:CreateOptions:Options:UserName:Password:
			argumentTypes: 'variant variant sdword sdword sdword bstr bstr';
		defineFunction: #Close;
		defineFunction: #get_Fields:
			argumentTypes: 'ADODBFields**';
		defineFunction: #get_RecordType:
			argumentTypes: 'sdword*';
		defineFunction: #GetChildren:
			argumentTypes: 'ADODB_Recordset**';
		defineFunction: #Cancel
! !
!ADODB_Record class categoriesFor: #clsid!**auto generated**!constants!private! !
!ADODB_Record class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

