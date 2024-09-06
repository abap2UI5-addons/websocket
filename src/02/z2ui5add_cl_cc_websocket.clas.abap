CLASS z2ui5add_cl_cc_websocket DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS get_js
      RETURNING
        VALUE(result) TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5add_cl_cc_websocket IMPLEMENTATION.

  METHOD get_js.

    result = `if (!z2ui5.Timer) {sap.ui.define("z2ui5/Websocket" , [` && |\n| &&
      `   "sap/ui/core/Control"` && |\n| &&
      `], (Control) => {` && |\n| &&
      `   "use strict";` && |\n| &&
      |\n| &&
      `   return Control.extend("z2ui5.Websocket", {` && |\n| &&
      `       metadata : {` && |\n| &&
      `           properties: {` && |\n| &&
            `          value: {` && |\n| &&
      `                    type: "string",` && |\n| &&
      `                    defaultValue: ""` && |\n| &&
      `                },` && |\n| &&
      `                path: {` && |\n| &&
      `                    type: "string",` && |\n| &&
      `                    defaultValue: "` && z2ui5add_cl_ws_channel_wrapper=>cv_ws_path && `"` && |\n| &&
      `                },` && |\n| &&
      `                checkActive: {` && |\n| &&
      `                    type: "boolean",` && |\n| &&
      `                    defaultValue: true` && |\n| &&
      `                },` && |\n| &&
      `                checkRepeat: {` && |\n| &&
      `                    type: "boolean",` && |\n| &&
      `                    defaultValue: false` && |\n| &&
      `                },` && |\n| &&
      `            },` && |\n| &&
      `            events: {` && |\n| &&
      `                 "received": { ` && |\n| &&
      `                        allowPreventDefault: true,` && |\n| &&
      `                        parameters: {},` && |\n| &&
      `                 }` && |\n| &&
      `            }` && |\n| &&
      `       },` && |\n| &&
      `       onAfterRendering() {` && |\n| &&
      `       },` && |\n| &&
      `       startWebsocket( oControl){` && |\n| &&
      `          if ( oControl.getProperty("checkActive") == false ){ return; }` && |\n| &&
*      `        if ( sap.z2ui5?.checkWS == true ){ return; }` && |\n| &&
      `       sap.z2ui5.checkWS = true;` && |\n| &&
      `          if ( oControl?.isActive == true ){ return; }` && |\n| &&
                     `   oControl.isActive = true;` && |\n|  &&
                     `  oControl.ws = new WebSocket(` && |\n|  &&
                          `    "ws://" + window.location.host + oControl.getProperty("path")` && |\n|  &&
                         `  );` && |\n|  &&
                   |\n|  &&
                  `  oControl.ws.onopen = function() {` && |\n|  &&
*                       `    alert("WebSocket opened");` && |\n|  &&
                `  };` && |\n|  &&
                     |\n|  &&
                 `  oControl.ws.onmessage = function (msg) {` && |\n|  &&
                      `    oControl.setValue(msg.data);` && |\n|  &&
                      `    oControl.fireReceived();` && |\n|  &&
                  `  };` && |\n|  &&
                          |\n|  &&
                    `  oControl.ws.onclose = function() {` && |\n|  &&
                         `     oControl.isActive = false;` && |\n|  &&
                         `    alert("WebSocket closed");` && |\n|  &&
                             `  };` && |\n|  &&
                        |\n|  &&
                    `  oControl.ws.onerror = function() {` && |\n|  &&
                          `    alert("WebSocket-Error");` && |\n|  &&
                     `  };` && |\n|  &&
      `       },` && |\n| &&
      `       renderer(oRm, oControl) {` && |\n| &&
      `        oControl.startWebsocket( oControl );` && |\n| &&
      `        }` && |\n| &&
      `   });` && |\n| &&
      `}); }`.

  ENDMETHOD.
ENDCLASS.
