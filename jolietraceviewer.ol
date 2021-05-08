#!/usr/bin/env jolie

from runtime import Runtime
from file import File

service Launcher {
	embed Runtime as runtime
	embed File as file
	main {
		if ( #args == 0 ) {
			port = "8000"
		} else {
			port = args[ 0 ]
		}

		getFileSeparator@file()( sep )
		getRealServiceDirectory@file()( home )

		loadEmbeddedService@runtime( {
			filepath = home + sep + "jolietraceviewer_service.ol"
			service = "Main"
			params << {
				location = "socket://localhost:" + port
				wwwDir = home + sep + "www" + sep
			}
		} )()

		linkIn( Exit )
	}
}