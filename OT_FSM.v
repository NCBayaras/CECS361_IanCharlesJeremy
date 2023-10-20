`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2023 08:42:08 AM
// Design Name: 
// Module Name: OT_FSM
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module OT_FSM(
    
    input clk,
    input reset,
    input [2:0] intake,
    //might need to be a register to accomodate multiple portions
    output LEDs
);
    
    reg[2:0] Current_State;
    reg[2:0] Next_State;
    
    //FSM declaration, initial state is standard_game
    // will need to figure out how to connect the standard game with the rest of the stuff
    localparam Standard_Game = 3'b000,
        // when game goes into overtime mode
        //or when neither player has advantage, "neutral"
        Overtime = 3'b001,
        // when player 1 has advantage
        p1_adv = 3'b010,
        // when Player 2 has advantage
        p2_adv = 3'b011,
        // player 1 wins
        p1_win = 3'b100,
        // player 2 wins
        p2_win = 3'b101;
    
    //Syntax weirdness FIX !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    //assign Current_State <= 3'b000;
    assign Next_State = 3'b000;
    
    always@ (posedge clk) begin
        
        if(reset)
            Current_State <= Standard_Game;
        else
            Current_State <= Next_State;
        
           
    end
   
    //
    always@ (*) begin
    
        Next_State = Current_State;
        
        case (Current_State)
            Standard_Game : begin
                //score is not tied at 12-12, game continues
                if(intake == 3'b000) Next_State = Standard_Game;
                
                //score tied at 12-12, overtime starts
                if (intake == 3'b001) Next_State = Overtime;
                
                // player 1 scored 13 points and player 2 not at 12 points
                if (intake == 3'b100) Next_State = p1_win;
                
                //player 2 scored 13 points and player 1 not at 12 points
                if (intake == 3'b101) Next_State = p2_win;
            end
            
            Overtime : begin
                // player 1 scores
                if (intake == 3'b010) Next_State = p1_adv;
                
                //player 2 scores
                if (intake == 3'b011) Next_State = p2_adv;
            end
            
            //when Player 1 has advantage
            p1_adv : begin
                //might need changing on the checked for value of intake, as depending on how we communicate
                // the score, it may need to be checking for 011
                //player 2 scores setting game back to neutral
                if (intake == 3'b001) Next_State = Overtime;
                
                //player 1 scores, winning
                if (intake == 3'b010) Next_State = p1_win;
           end     
          
           p2_adv : begin
              //might need changing on the checked for value of intake, as depending on how we communicate
              // the score, it may need to be checking for 010, currently looking for overtime signal
              //player 1 scores setting game back to neutral
              if (intake == 3'b001) Next_State = Overtime;
              
              //player 2 scores, winning
              if (intake == 3'b011) Next_State = p2_win;
         end
         
         p1_win : begin
            //send stuff to the corresponding modules to be converted into feedback
            //such as with LEDs and the like
         end
            
        p2_win : begin
            //send stuff to the corresponding modules to be converted into feedback
            //such as with LEDs and the like
         end
      endcase
    end
    
    
endmodule
