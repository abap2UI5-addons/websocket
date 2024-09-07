CLASS z2ui5add_cl_ws_channel_wrapper DEFINITION PUBLIC
  INHERITING FROM cl_apc_wsp_ext_stateless_base
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS if_apc_wsp_extension~on_start
        REDEFINITION .
    METHODS if_apc_wsp_extension~on_message
        REDEFINITION .

    INTERFACES if_amc_message_receiver_text.

    CLASS-DATA cv_ws_path TYPE string VALUE `/sap/bc/apc/sap/z2ui5_apc_draft`.
    DATA gr_consumer  TYPE REF TO if_amc_message_consumer.
    DATA gt_messages  TYPE TABLE OF string.
    DATA gv_message   TYPE string.
    DATA gv_nr        TYPE i.
    DATA gr_amc_error TYPE REF TO cx_amc_error.

    CLASS-METHODS receive_messages
      IMPORTING
        wait_time_sec TYPE i DEFAULT 10
        number        TYPE i DEFAULT 1
      RETURNING
        VALUE(result) TYPE string_table.

    CLASS-METHODS send_text
      IMPORTING
        message TYPE clike.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5add_cl_ws_channel_wrapper IMPLEMENTATION.

  METHOD receive_messages.

    DATA gr_consumer  TYPE REF TO if_amc_message_consumer.
    DATA gt_messages  TYPE TABLE OF string.
    DATA gv_message   TYPE string.
    DATA gv_nr        TYPE i.
    DATA gr_amc_error TYPE REF TO cx_amc_error.

    DATA(gr_receiver) = NEW z2ui5add_cl_ws_channel_wrapper( ).

    TRY.
        gr_consumer =
          cl_amc_channel_manager=>create_message_consumer(
            i_application_id =  'Z2UI5_AMC_DRAFT'
            i_channel_id = '/main' ).

        gr_consumer->start_message_delivery(
          i_receiver = gr_receiver ).

      CATCH cx_amc_error INTO gr_amc_error.
        MESSAGE gr_amc_error->get_text( ) TYPE 'E'.
    ENDTRY.

    WAIT FOR MESSAGING CHANNELS UNTIL gr_receiver->gv_nr >= number
      UP TO wait_time_sec SECONDS.
    IF sy-subrc = 8.
      IF  gv_nr = 0.

      ELSEIF gv_nr < number.

      ENDIF.
    ELSE.

    ENDIF.

    result = gr_receiver->gt_messages.

  ENDMETHOD.

  METHOD send_text.

    TRY.

        DATA gr_producer_text TYPE REF TO if_amc_message_producer_text.
        DATA  gr_amc_error     TYPE REF TO cx_amc_error.

        gr_producer_text ?=
          cl_amc_channel_manager=>create_message_producer(
            i_application_id =  'Z2UI5_AMC_DRAFT'
            i_channel_id = '/main'
        ).

        gr_producer_text->send( message ).

      CATCH cx_amc_error INTO gr_amc_error.
        z2ui5_cl_util=>x_raise( gr_amc_error->get_text( ) ).
    ENDTRY.

  ENDMETHOD.

  METHOD if_amc_message_receiver_text~receive.
    APPEND i_message TO gt_messages.
    ADD 1 TO gv_nr.
  ENDMETHOD.

  METHOD if_apc_wsp_extension~on_message.

  ENDMETHOD.


  METHOD if_apc_wsp_extension~on_start.

*    DATA: lt_form_fields TYPE tihttpnvp.
*    DATA: lt_head_fields TYPE tihttpnvp.
*    DATA: lt_cookie      TYPE tihttpcki.
*
    TRY.
*
*        DATA(lo_req) = i_context->get_initial_request( ).
*        lo_req->get_form_fields(
*          CHANGING
*            c_fields             = lt_form_fields ).
*        lo_req->get_header_fields(
*          CHANGING
*            c_fields     = lt_head_fields ).
*        lo_req->get_cookies(
*          CHANGING
*            c_cookies    = lt_cookie
*        ).
*        CATCH cx_apc_error.    "

        i_context->get_binding_manager( )->bind_amc_message_consumer(
                  i_application_id =  'Z2UI5_AMC_DRAFT'
                  i_channel_id     = '/main' ).

      CATCH cx_apc_error INTO DATA(exc).
        MESSAGE exc->get_text( ) TYPE 'X'.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
