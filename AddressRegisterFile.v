`timescale 1ns / 1ps

module AddressRegisterFile(
    input Clock,
    input [1:0] FunSel,
    input [2:0] RegSel,
    input [1:0] OutCSel,
    input [1:0] OutDSel,
    input [15:0] I,
    output [15:0] OutC,
    output [15:0] OutD
);

wire [15:0] pc_out, ar_out, sp_out;

// Register16bit bağlantıları — DOĞRU SIRALAMA
Register16bit PC (
    .Clock(Clock),
    .rst(1'b0),
    .E(RegSel[2]),  // ← PC: RegSel[2]
    .FunSel(FunSel),
    .I(I),
    .Q(pc_out)
);

Register16bit AR (
    .Clock(Clock),
    .rst(1'b0),
    .E(RegSel[0]),  // ← AR: RegSel[0]
    .FunSel(FunSel),
    .I(I),
    .Q(ar_out)
);

Register16bit SP (
    .Clock(Clock),
    .rst(1'b0),
    .E(RegSel[1]),  // ← SP: RegSel[1]
    .FunSel(FunSel),
    .I(I),
    .Q(sp_out)
);

// Output seçimleri sabit kalabilir
assign OutC = (OutCSel == 2'b00) ? pc_out :
              (OutCSel == 2'b01) ? sp_out :
              ar_out;

assign OutD = (OutDSel == 2'b00) ? pc_out :
              (OutDSel == 2'b01) ? sp_out :
              ar_out;

endmodule