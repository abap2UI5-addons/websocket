CLASS z2ui5_cl_draft_test_send DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA message  TYPE string.
    DATA check_initialized TYPE abap_bool.

  PROTECTED SECTION.

    DATA mo_last_draft TYPE REF TO z2ui5_if_app.
    DATA client        TYPE REF TO z2ui5_if_client.

    METHODS display_view.
    METHODS on_event.

  PRIVATE SECTION.

ENDCLASS.



CLASS z2ui5_cl_draft_test_send IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      display_view(  ).
      RETURN.
    ENDIF.

    on_event( ).

  ENDMETHOD.

  METHOD display_view.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    client->view_display( view->shell(
         )->page(
                 title          = 'abap2UI5 - Send ABAP Channel Message'
                 navbuttonpress = client->_event( val = 'BACK' s_ctrl = VALUE #( check_view_destroy = abap_true ) )
                 shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
             )->simple_form( title = 'Form Title' editable = abap_true
                 )->content( 'form'
                     )->title( 'Input'
                     )->label( 'Message'
                     )->input( client->_bind_edit( message )
                     )->button(
                         text  = 'Send Message'
                         press = client->_event( val = 'BUTTON_POST' )
          )->stringify( ) ).

  ENDMETHOD.



  METHOD on_event.

    CASE client->get( )-event.

      WHEN 'BUTTON_POST'.

        TRY.
            z2ui5_cl_draft_channel_wrapper=>send_text( message ).
            client->message_toast_display( `Message send!` ).
          CATCH cx_root INTO DATA(lx).
            client->message_box_display( lx->get_text( ) ).
        ENDTRY.

      WHEN 'BACK'.
        client->nav_app_leave( ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
