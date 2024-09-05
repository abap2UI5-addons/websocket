CLASS z2ui5add_cl_ws_channel_wrapper DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

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

*
    WAIT FOR MESSAGING CHANNELS UNTIL gr_receiver->gv_nr >= number
      UP TO wait_time_sec SECONDS.
    IF sy-subrc = 8.
      IF  gv_nr = 0.
*        WRITE: 'Time-Out aufgetreten,',
*               'keine Nachrichten empfangen.'.
      ELSEIF gv_nr < number.
*        WRITE: 'Time-Out aufgetreten,',
*               'nicht alle Nachrichten empfangen.'.
      ENDIF.
    ELSE.
*      WRITE: 'Alle Nachrichten empfangen.'.
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

ENDCLASS.
