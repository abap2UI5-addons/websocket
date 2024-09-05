  CLASS z2ui5add_cl_ws_test_receive_b DEFINITION PUBLIC.

    PUBLIC SECTION.

      INTERFACES z2ui5_if_app.

      DATA number   TYPE i VALUE 1.
      DATA wait_time TYPE i VALUE 20.

      DATA check_initialized TYPE abap_bool.

    PROTECTED SECTION.

      DATA mo_last_draft TYPE REF TO z2ui5_if_app.
      DATA client        TYPE REF TO z2ui5_if_client.

      METHODS display_view.
      METHODS on_event.

    PRIVATE SECTION.

  ENDCLASS.


  CLASS z2ui5add_cl_ws_test_receive_b IMPLEMENTATION.

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
                       )->label( 'Number'
                       )->input( client->_bind_edit( number )
                            )->label( 'Time in Sec'
                       )->input( client->_bind_edit( wait_time )
                       )->button(
                           text  = 'Check for Messages'
                           press = client->_event( val = 'BUTTON_POST' )
            )->stringify( ) ).

    ENDMETHOD.



    METHOD on_event.

      CASE client->get( )-event.

        WHEN 'BUTTON_POST'.
          z2ui5add_cl_ws_channel_wrapper=>receive_messages(
*              EXPORTING
*                wait_time_sec = 10
*                number        = 1
            RECEIVING
              result        = DATA(lt_messages)
          ).

          DATA(lv_string) = ` `.
          LOOP AT lt_messages INTO DATA(gv_message).
            lv_string = lv_string && gv_message.
          ENDLOOP.

          client->message_box_display(  `Messages received` && lv_string ).

        WHEN 'BACK'.
          client->nav_app_leave( ).

      ENDCASE.

    ENDMETHOD.



  ENDCLASS.
