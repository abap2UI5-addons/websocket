CLASS z2ui5_cl_ext_draft_sample DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA product  TYPE string.
    DATA quantity TYPE string.
    DATA check_initialized TYPE abap_bool.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_ext_draft_sample IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF check_initialized = abap_false.


      DATA(lo_app) = NEW  z2ui5_cl_ext_draft( )->load( 'MY_DRAFT_TEST' ).
      IF lo_app IS BOUND.
        client->nav_app_leave( lo_app ).
        RETURN.
      ENDIF.
      product  = 'tomato'.
      quantity = '500'.

endif.

    if check_initialized = abap_false or client->get( )-check_on_navigated = abap_true.

      DATA(view) = z2ui5_cl_xml_view=>factory( ).
      client->view_display( view->shell(
           )->page(
                   title          = 'abap2UI5 - First Example'
                   navbuttonpress = client->_event( val = 'BACK' s_ctrl = VALUE #( check_view_destroy = abap_true ) )
                   shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
               )->simple_form( title = 'Form Title' editable = abap_true
                   )->content( 'form'
                       )->title( 'Input'
                       )->label( 'quantity'
                       )->input( client->_bind_edit( quantity )
                       )->label( `product`
                       )->input( value = product enabled = abap_false
                       )->button(
                           text  = 'save draft'
                           press = client->_event( val = 'BUTTON_POST' )
            )->stringify( ) ).

    ENDIF.

   check_initialized = abap_true.

    CASE client->get( )-event.

      WHEN 'BUTTON_POST'.
        NEW  z2ui5_cl_ext_draft( )->save(
          id   = client->get( )-s_draft-id
          name = 'MY_DRAFT_TEST'
        ).
        client->message_toast_display( text = |{ product } { quantity } - send to the server| ).

      WHEN 'BACK'.
        client->nav_app_leave( ).

    ENDCASE.

  ENDMETHOD.
ENDCLASS.
