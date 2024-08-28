*&---------------------------------------------------------------------*
*& Report z2ui5_re_draft_test_amc_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z2ui5_re_draft_test_amc_01.


PARAMETERS:
  pa_nr   TYPE i DEFAULT 1,  " Anzahl erwarteter Nachrichten
  pa_wait TYPE i DEFAULT 20. " Wartezeit in Sekunden
DATA:
  gr_consumer  TYPE REF TO if_amc_message_consumer,
  gt_messages  TYPE TABLE OF string,
  gv_message   TYPE string,
  gv_nr        TYPE i, " Anzahl empfangener Nachrichten
  gr_amc_error TYPE REF TO cx_amc_error.
* Implementierungsklasse für die AMC-Empfängerschnittstelle

CLASS lcl_amc_receiver DEFINITION
FINAL
  CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_amc_message_receiver_text.
ENDCLASS.

CLASS lcl_amc_receiver IMPLEMENTATION.
  METHOD if_amc_message_receiver_text~receive.
* Nachricht in die globale interne Tabelle einfügen
    APPEND i_message TO gt_messages.
    ADD 1 TO gv_nr.
  ENDMETHOD.
endclass.


START-OF-SELECTION.

  DATA: gr_receiver TYPE REF TO lcl_amc_receiver.
  TRY.
      gr_consumer =
        cl_amc_channel_manager=>create_message_consumer(
          i_application_id =  'ZLS_AMC_01'
          i_channel_id = '/test' ).
      CREATE OBJECT gr_receiver.
      " Empfänger subskribieren
      gr_consumer->start_message_delivery(
        i_receiver = gr_receiver ).
    CATCH cx_amc_error INTO gr_amc_error.
      MESSAGE gr_amc_error->get_text( ) TYPE 'E'.
  ENDTRY.
* So lange warten, bis alle Nachrichten empfangen wurden,
* jedoch nicht länger als die Wartezeit.
*
  WAIT FOR MESSAGING CHANNELS UNTIL gv_nr >= pa_nr
    UP TO pa_wait SECONDS.
  IF sy-subrc = 8.
    IF  gv_nr = 0.
      WRITE: 'Time-Out aufgetreten,',
             'keine Nachrichten empfangen.'.
    ELSEIF gv_nr < pa_nr.
      WRITE: 'Time-Out aufgetreten,',
             'nicht alle Nachrichten empfangen.'.
    ENDIF.
  ELSE.
    WRITE: 'Alle Nachrichten empfangen.'.
  ENDIF.

  LOOP AT gt_messages INTO gv_message.
    "Liste der Nachrichten ausgeben
    WRITE: / sy-tabix, gv_message.
  ENDLOOP.
