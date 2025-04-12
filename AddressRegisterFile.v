module AddressRegisterFile(
    input clk,
    input rst,
    input E,
    input [1:0] FunSel,
    input [2:0] RegSel,
    input [1:0] OutCSel,
    input [1:0] OutDSel,
    input [15:0] I,
    output reg [15:0] OutC,
    output reg [15:0] OutD
);

// 3 adet 16-bit register
reg [15:0] PC, AR, SP;

always @(posedge clk) begin
    if (rst) begin
        PC <= 16'b0;
        AR <= 16'b0;
        SP <= 16'b0;
    end
    else if (E) begin
        if (RegSel[0]) PC <= apply_function(PC, FunSel, I);
        if (RegSel[1]) AR <= apply_function(AR, FunSel, I);
        if (RegSel[2]) SP <= apply_function(SP, FunSel, I);
    end
end

// Çıkış seçimleri
always @(*) begin
    case (OutCSel)
        2'b00: OutC = PC;
        2'b01: OutC = SP;
        default: OutC = AR;
    endcase

    case (OutDSel)
        2'b00: OutD = PC;
        2'b01: OutD = SP;
        default: OutD = AR;
    endcase
end

// Fonksiyon uygulama bloğu
function [15:0] apply_function;
    input [15:0] current;
    input [1:0] fs;
    input [15:0] data;

    begin
        case (fs)
            2'b00: apply_function = current - 1;
            2'b01: apply_function = current + 1;
            2'b10: apply_function = data;
            2'b11: apply_function = 16'b0;
            default: apply_function = current;
        endcase
    end
endfunction

endmodule
