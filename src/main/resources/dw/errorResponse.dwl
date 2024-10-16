%dw 2.0
//var errPayload = ((error.errorMessage.payload pluck $$) filter ($ contains "environment"))
output application/json skipNullOn = 'everywhere'
---
{
	"applicationName": p("json.logger.application.name"),
	"environment": p('env') default "",
	"statusCode": if (error.errorMessage.payload != null) (if ((sizeOf(vars.errPayload) == 1) and (error.errorMessage.payload.statusCode != null) ) (error.errorMessage.payload.statusCode) else (vars.errorCode default 500)) else vars.errorCode default 500,
	"status": "FAILURE",
	"errorType": if (error.errorMessage.payload != null) (if ( (sizeOf(vars.errPayload) == 1) and (error.errorMessage.payload.errorType != null) ) (error.errorMessage.payload.errorType) else vars.errorType default "") else vars.errorType default "",
	"errorDescription": if(!isEmpty(error.description)) error.description else vars.errorMessage default "System Error Occurred while executing the API Call",
	"errorDetailedDescription": if (error.errorMessage.payload != null) (if ((sizeOf(vars.errPayload) == 1) and (error.errorMessage.payload.DetailedDescription != null) ) (error.errorMessage.payload.DetailedDescription) 
								else (vars.errorMessage default (error.exception.exceptionMessage default error.muleMessage.payload default error.detailedDescription default ""))) else (vars.errorMessage default error.exception.exceptionMessage default error.muleMessage.payload default error.detailedDescription default "System Error Occurred"),						
	"transactionId": vars.transactionId default correlationId,
	"timeStamp": now() as DateTime {format:"yyyy-MM-dd'T'HH:mm:ss"}
}