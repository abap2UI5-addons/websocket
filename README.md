## Websocket Feature


Work in progress... 🚧 🏗️ 🦺



### Installation 

Install with abapGir and extend your HTTP handler with:
```abap
  METHOD if_http_extension~handle_request.

    DATA(response) = z2ui5_cl_http_handler=>main(
                       body   = server->request->get_cdata( )
                       config = VALUE #( custom_js = z2ui5add_cl_cc_websocket=>get_js( ) )
                     ).
    server->response->set_cdata( response ).
    server->response->set_header_field( name = `cache-control` value = `no-cache` ).
    server->response->set_status( code = 200 reason = `success` ).

  ENDMETHOD.
```


