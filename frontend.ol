from file import File
from string_utils import StringUtils

type GetTraceListResponse: void {
    .trace*: string
}

type GetTraceLineRequest: void {
    .line: int
}

interface FrontendInterface {
    RequestResponse:
        getTraceList( void )( GetTraceListResponse ),
        getTraceLine( GetTraceLineRequest )( string ),
        getTrace( string )( string ),
        getServiceFile( string )( string )
}

service Main {
	execution: concurrent

	embed File as File
	embed StringUtils as StringUtils

	inputPort Frontend {
		location: "local"
		interfaces: FrontendInterface
	}

	main {
		[ getTrace( request )( response ) {
			f.filename = request
			readFile@File( f )( response )
		} ] {
			split@StringUtils( response { .regex = "\\n" } )( global.trace_lines )
		}

		[ getTraceList( request )( response ) {
			list@File( { .directory=".", .regex=".*\\.jolie\\.log\\.json"} )( list )
			traceCount = 0
			for( trace in list.result ) {
				response.trace[ traceCount ] = trace
				traceCount++
			}
		}]

		[ getTraceLine( request )( response ) {
			response = global.trace_lines.result[ request.line ]
		}]

		[ getServiceFile( request )( response ) {
			f.filename = request
			readFile@File( f )( response )
		}]
	}
}
