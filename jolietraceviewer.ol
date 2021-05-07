#!/usr/bin/env jolie

from runtime import Runtime

service Launcher {
	embed Runtime as runtime
	main {
		if ( #args == 0 ) {
			port = "8000"
		} else {
			port = args[ 0 ]
		}
		with( emb ) {
			.filepath = "-C Location=\"socket://localhost:" + port + "\" jolietraceviewer_service.ol";
			.type = "Jolie"
		}
		loadEmbeddedService@runtime( emb )(  )

		linkIn( Exit )
	}
}