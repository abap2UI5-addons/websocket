CLASS z2ui5add_cl_ws_sample_01 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.
    data mv_message type string.

  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS z2ui5_on_event.
    METHODS z2ui5_view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5add_cl_ws_sample_01 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client     = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      z2ui5_view_display( ).
    ENDIF.

    IF client->get( )-event IS NOT INITIAL.
      z2ui5_on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD z2ui5_on_event.

    CASE client->get( )-event.

      WHEN 'WS_MESSAGE_RECEIVED'.
        client->message_box_display( `Message receiced: ` && mv_message ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.



  METHOD z2ui5_view_display.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).

    lo_view->_z2ui5( )->websocket(
        received = client->_event( 'WS_MESSAGE_RECEIVED' )
        value = client->_bind_edit( mv_message ) ).

    DATA(page) = lo_view->shell( )->page(
             title          = 'abap2UI5 - Websocket - This app just waits for messages...'
             navbuttonpress = client->_event( 'BACK' )
             shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
         ).

    client->view_display( lo_view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
