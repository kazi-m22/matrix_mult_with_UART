//************************** ATTEMPT 3 State machine *************************


module top( input [15:0] sw,
            input Clock,
            output [15:0] led            
            );  //testbench module is always empty. No input or output ports.

reg [71:0] A;
reg [71:0] B;
reg [3:0] i;

wire [71:0] C;

reg [1:0] present_state, next_state;
reg reset, Enable;
wire done, en_st;

localparam START = 2'b01;
localparam RUN = 2'b10;
localparam FINISH = 2'b11;



always @(present_state, i, C, next_state)
begin
    case(present_state)

    START:
        begin
            reset = 1;
            Enable = 0;
            next_state = RUN;
            i= 4'b0;
        end

    RUN:
        begin
        reset = 0;
        Enable = 1;
        if (done == 1)
            next_state <= FINISH;

        end
        
    FINISH:
        begin
	           next_state <= START;
        end
        
    default:
        next_state <= START;

    endcase
end

always @(posedge Clock)
begin
    if(en_st == 1'b1)
        present_state <= next_state;
end


initial
begin

    reset =0;

    //input matrices are set and Enable input is set High
    A = {8'd9,8'd8,8'd7,8'd6,8'd5,8'd4,8'd3,8'd2,8'd1};
    B = {8'd1,8'd9,8'd8,8'd7,8'd6,8'd5,8'd4,8'd3,8'd2};
    
    present_state = 2'b01;

end


assign led[0] = done;
assign en_st = sw[0];
assign led[15:8] = C[7:0];

//Instantiate the matrix multiplier
matrix_mult matrix_multiplier 
        (.Clock(Clock), 
        .reset(reset), 
        .Enable(Enable), 
        .A(A),
        .B(B), 
        .C(C),
        .done(done));


endmodule 

//************************** ATTEMPT 2 ***************************************



//sw[0] = enbale
//reset = sw[1] 
//Enabel  = sw[0] (right most in the fpga board)
//attaching FIFO to send 72 bits


//module top (input Clock,
//            input [15:0] sw,
//            output [15:0] led,
//            output TxD );

//reg [71:0] A;
//reg [71:0] B;
//wire [71:0] C;
//reg [7:0] data;
//integer i;
//reg reset, Enable, reset_tr, transmit;
//wire done;

////integer i,j;
////parameter Clock_period = 10; 

//localparam START = 2'b00;
//localparam INIT = 2'b01;
//localparam CAL_MAT= 2'b10;
//localparam LOOP_BODY = 2'b11;

//reg [1:0] present_state, next_state;

////assign led[15:8] = C[7:0];
//assign led[0] = done;

//always @(present_state, done)
//begin
    
////    Enable = sw[0];
////    reset = sw[1];
    
//    case(present_state)
//    START:
//    begin
//        Enable = 1'b0;
//        reset = 1'b0;
//        reset_tr = 1'b0;
//        data = 1'b0;
//        next_state = INIT;
//    end
    
//    INIT:
//    begin
//        reset = 1'b1;
//        reset_tr = 1'b1;
//        next_state = CAL_MAT;
//    end
    
//    CAL_MAT:
//    begin
//        reset = 1'b0;
//        reset_tr = 1'b0;
//        Enable = 1'b1;
//        if (done == 1'b1)
//            next_state = LOOP_BODY;
//    end
    
//    LOOP_BODY:
//    begin
        
//        for (i = 0; i<72; i = i + 8) begin
//            data[7:0] = C[i +: 8];
//            transmit = 1;
//        end
        
//        next_state = START;
//    end
    
//    endcase
//end

//always @(posedge Clock)
//begin
//    present_state = next_state;
//end
////end

//initial
//begin
////    Clock = 1;
//    reset = 1;
//    #100;   //Apply reset for 100 ns before applying inputs.
//    reset = 0;
////    #Clock_period;
//    //input matrices are set and Enable input is set High
//    A = {8'd9,8'd8,8'd7,8'd6,8'd5,8'd4,8'd3,8'd2,8'd1};
//    B = {8'd1,8'd9,8'd8,8'd7,8'd6,8'd5,8'd4,8'd3,8'd2};
//    present_state = 2'b00;

//end


//transmitter T1 (.clk(Clock), .reset(reset_tr),.transmit(transmit),.TxD(TxD),.data(data));


//matrix_mult matrix_multiplier 
//        (.Clock(Clock), 
//        .reset(reset), 
//        .Enable(Enable), 
//        .A(A),
//        .B(B), 
//        .C(C),
//        .done(done));
    
//endmodule 










////****************************************initial try 1***********************************************
//sw[0] = enbale
//sw[15]- w[12] => B, divided by 4 switches
//reset = sw[1] 
//Enabel  = sw[0] (right most in the fpga board)

//module top (input Clock,
//            input [15:0] sw,
//            output [15:0] led);

//reg [71:0] A;
//reg [71:0] B;
//reg [71:0] F;
//reg [71:0] G;
//reg [71:0] D;
//reg [71:0] E;

//wire [71:0] C;

//reg reset, Enable;
//wire done;

//integer i,j;
//parameter Clock_period = 10; 

//assign led[15:8] = C[7:0];
//assign led[0] = done;

//always @(*)
//begin
    
//    Enable = sw[0];
//    reset = sw[1];
    
    
//end
////end

//initial
//begin
////    Clock = 1;
//    reset = 1;
//    #100;   //Apply reset for 100 ns before applying inputs.
//    reset = 0;
//    #Clock_period;
//    //input matrices are set and Enable input is set High
//    A = {8'd9,8'd8,8'd7,8'd6,8'd5,8'd4,8'd3,8'd2,8'd1};
//    B = {8'd1,8'd9,8'd8,8'd7,8'd6,8'd5,8'd4,8'd3,8'd2};


//end

//matrix_mult matrix_multiplier 
//        (.Clock(Clock), 
//        .reset(reset), 
//        .Enable(Enable), 
//        .A(A),
//        .B(B), 
//        .C(C),
//        .done(done));
    
//endmodule 