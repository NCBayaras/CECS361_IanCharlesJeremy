module Top(
    input clock, // 100 Mhz clock source on Basys 3 FPGA
    input reset, // reset
    input reset_points, // reset game score
    input reset_score,  //reset time clock
    input one_point_t1, //input to increment 1 point
    input one_point_t2, //input to increment 1 point
    input pause,  //pause timer
    output reg [7:0] Anode_Activate, // anode signals of the 7-segment LED display
    output reg [6:0] LED_out// cathode patterns of the 7-segment LED display
);
    reg [15:0] Showing_Numbers;   // counting number to be displayed
    reg [7:0] t1; //used to store teams score
    reg [7:0] t2; //used to store teams score
    reg [7:0] LED_BCD;//used to out put scores and timer
    reg [19:0] refresh_counter; 
    wire [2:0] LED_Counter; 

assign LED_Counter = refresh_counter[19:17];//used 3 instead of 19:18
    // anode activating signals for 8 LEDs, digit period of 2.6ms
    // decoder to generate anode signals 
    always @(*)
    begin
        case(LED_Counter)
        3'b000: begin
            Anode_Activate = 8'b11111110; 
            // activate LED1 and Deactivate LED2, LED3, LED4, LED5, LED6, LED7, LED8
             LED_BCD = minutes / 10;//10s place
            // the first digit of the 16-bit number (Team 1 Score)
              end
        3'b001: begin
            Anode_Activate = 8'b11111101; 
            // activate LED2 and Deactivate LED1, LED3, LED4, LED5, LED6, LED7, LED8
            LED_BCD = minutes % 10;//1s place
            // the second digit of the 16-bit number(Team 1 Score)
              end
        3'b010: begin
            Anode_Activate = 8'b11111011; 
            // activate LED3 and Deactivate LED2, LED1, LED4, LED5, LED6, LED7, LED8
             LED_BCD = seconds / 10;//10s place
            // the third digit of the 16-bit number (Timer)
                end
        3'b011: begin
            Anode_Activate = 8'b11110111; 
            // activate LED4 and Deactivate LED2, LED3, LED1, LED5, LED6, LED7, LED8
             LED_BCD = seconds % 10;//1s place
            // the fourth digit of the 16-bit number  (Timer)
               end
        3'b100: begin
            Anode_Activate = 8'b11101111; 
            // activate LED5 and Deactivate LED2, LED3, LED4, LED5, LED1, LED7, LED8
                LED_BCD = (t2 / 10);//10s place
            // the first digit of the 16-bit number(Timer)
              end
        3'b101: begin
            Anode_Activate = 8'b11011111; 
            // activate LED6 and Deactivate LED1, LED3, LED4, LED5, LED2, LED7, LED8
                LED_BCD = (t2 % 10);//1s place
            // the second digit of the 16-bit number(Timer)
              end
        3'b110: begin
            Anode_Activate = 8'b10111111; 
            // activate LED7 and Deactivate LED2, LED1, LED4, LED5, LED6, LED3, LED8
                LED_BCD = (t1 / 10);
            // the third digit of the 16-bit number and show 6 (Team 2)
                end
        3'b111: begin
            Anode_Activate = 8'b01111111; // leading bit is zero. So turn on first led. 
            // activate LED8 and Deactivate LED2, LED3, LED1, LED5, LED6, LED7, LED4
                LED_BCD = (t1 % 10);
            // the fourth digit of the 16-bit number (Team 2)
               end
        endcase
    end   
    // Cathode patterns of the 7-segment LED display 
    always @(*)
    begin
        case(LED_BCD)
       0: LED_out = 7'b0000001; // "0"     
       1: LED_out = 7'b1001111; // "1" 
       2: LED_out = 7'b0010010; // "2" 
       3: LED_out = 7'b0000110; // "3" 
       4: LED_out = 7'b1001100; // "4" 
       5: LED_out = 7'b0100100; // "5" 
       6: LED_out = 7'b0100000; // "6" 
       7: LED_out = 7'b0001111; // "7" 
       8: LED_out = 7'b0000000; // "8"     
       9: LED_out = 7'b0000100; // "9" 
       default: LED_out = 7'b0000001; // "0"
        endcase
    end