#!/usr/bin/env jolie

include "runtime.iol"


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
	loadEmbeddedService@Runtime( emb )(  )

	linkIn( Exit )
}