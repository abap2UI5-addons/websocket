CLASS z2ui5add_cl_ws_sample_01 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_row,
        title    TYPE string,
        value    TYPE string,
        descr    TYPE string,
        icon     TYPE string,
        info     TYPE string,
        checkbox TYPE abap_bool,
      END OF ty_row.
    DATA t_tab TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.

    DATA mv_counter TYPE i.
    data mv_message type string.
    DATA mv_check_active TYPE abap_bool.

  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS z2ui5_on_init.
    METHODS z2ui5_on_event.
    METHODS z2ui5_view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5add_cl_ws_sample_01 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client     = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      z2ui5_on_init( ).
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

*        client->view_model_update( ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_on_init.

    mv_counter = 1.
    mv_check_active = abap_true.

    t_tab = VALUE #(
            ( title = 'entry' && mv_counter  info = 'completed'   descr = 'this is a description' icon = 'sap-icon://account' ) ).

  ENDMETHOD.


  METHOD z2ui5_view_display.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).

    lo_view->_z2ui5( )->websocket(
        received = client->_event( 'WS_MESSAGE_RECEIVED' )
        value = client->_bind_edit( mv_message )
        checkactive = client->_bind( mv_check_active )  ).

    DATA(page) = lo_view->shell( )->page(
             title          = 'abap2UI5 - Websocket - Receive Data'
             navbuttonpress = client->_event( 'BACK' )
             shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
         )->header_content(
             )->link( text = 'Demo'    target = '_blank'    href = `https://twitter.com/abap2UI5/status/1645816100813152256`
             )->link(
                 text = 'Source_Code' target = '_blank'
         )->get_parent( ).

    page->list(
         headertext = 'Data auto refresh (2 sec)'
         items      = client->_bind( t_tab )
         )->standard_list_item(
             title       = '{TITLE}'
             description = '{DESCR}'
             icon        = '{ICON}'
             info        = '{INFO}' ).

    client->view_display( lo_view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
