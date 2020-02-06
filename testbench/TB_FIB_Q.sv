/*=============================================================================
 * Title        : Fibonacci function quadruple calculation testbench
 *
 * File Name    : TB_FIB_Q.sv
 * Project      : 
 * Block        : 
 * Tree         : 
 * Designer     : toms74209200 <https://github.com/toms74209200>
 * Created      : 2020/01/29
 * License      : MIT License.
                  http://opensource.org/licenses/mit-license.php
 *============================================================================*/

`timescale 1ns/1ns

`define MessageOK(variable) \
$messagelog("%:S %:F(%:L) OK:Assertion %:O.", "Note", `__FILE__, `__LINE__, variable);
`define MessageERROR(variable) \
$messagelog("%:S %:F(%:L) ERROR:Assertion %:O failed.", "Error", `__FILE__, `__LINE__, variable);
`define ChkValue(variable, value) \
    if ((variable)===(value)) \
        `MessageOK(variable) \
    else \
        `MessageERROR(variable)

module TB_FIB_Q ;

// Simulation module signal
bit         RESET_n;            //(n) Reset
bit         CLK;                //(p) Clock
bit         ASI_READY = 0;      //(p) Avalon-ST sink data ready
bit         ASI_VALID = 0;      //(p) Avalon-ST sink data valid
bit [63:0]  ASI_DATA  = 0;      //(p) Avalon-ST sink data
bit         ASO_VALID;          //(p) Avalon-ST source data valid
bit [63:0]  ASO_DATA;           //(p) Avalon-ST source data
bit         ASO_ERROR;          //(p) Avalon-ST source error

// Parameter
parameter ClkCyc    = 10;       // Signal change interval(10ns/50MHz)
parameter ResetTime = 20;       // Reset hold time

// Data rom
bit [63:0] fibonacci_data_rom[1:100];

// module
FIB_Q U_FIB_Q(
.*,
.ASI_READY(ASI_READY),
.ASI_VALID(ASI_VALID),
.ASI_DATA(ASI_DATA),
.ASO_VALID(ASO_VALID),
.ASO_DATA(ASO_DATA),
.ASO_ERROR(ASO_ERROR)
);

/*=============================================================================
 * Clock
 *============================================================================*/
always begin
    #(ClkCyc);
    CLK = ~CLK;
end


/*=============================================================================
 * Reset
 *============================================================================*/
initial begin
    #(ResetTime);
    RESET_n = 1;
end 


/*=============================================================================
 * ROM
 *============================================================================*/
initial begin
    fibonacci_data_rom[1]   = 64'd1;
    fibonacci_data_rom[2]   = 64'd1;
    fibonacci_data_rom[3]   = 64'd2;
    fibonacci_data_rom[4]   = 64'd3;
    fibonacci_data_rom[5]   = 64'd5;
    fibonacci_data_rom[6]   = 64'd8;
    fibonacci_data_rom[7]   = 64'd13;
    fibonacci_data_rom[8]   = 64'd21;
    fibonacci_data_rom[9]   = 64'd34;
    fibonacci_data_rom[10]  = 64'd55;
    fibonacci_data_rom[11]  = 64'd89;
    fibonacci_data_rom[12]  = 64'd144;
    fibonacci_data_rom[13]  = 64'd233;
    fibonacci_data_rom[14]  = 64'd377;
    fibonacci_data_rom[15]  = 64'd610;
    fibonacci_data_rom[16]  = 64'd987;
    fibonacci_data_rom[17]  = 64'd1597;
    fibonacci_data_rom[18]  = 64'd2584;
    fibonacci_data_rom[19]  = 64'd4181;
    fibonacci_data_rom[20]  = 64'd6765;
    fibonacci_data_rom[21]  = 64'd10946;
    fibonacci_data_rom[22]  = 64'd17711;
    fibonacci_data_rom[23]  = 64'd28657;
    fibonacci_data_rom[24]  = 64'd46368;
    fibonacci_data_rom[25]  = 64'd75025;
    fibonacci_data_rom[26]  = 64'd121393;
    fibonacci_data_rom[27]  = 64'd196418;
    fibonacci_data_rom[28]  = 64'd317811;
    fibonacci_data_rom[29]  = 64'd514229;
    fibonacci_data_rom[30]  = 64'd832040;
    fibonacci_data_rom[31]  = 64'd1346269;
    fibonacci_data_rom[32]  = 64'd2178309;
    fibonacci_data_rom[33]  = 64'd3524578;
    fibonacci_data_rom[34]  = 64'd5702887;
    fibonacci_data_rom[35]  = 64'd9227465;
    fibonacci_data_rom[36]  = 64'd14930352;
    fibonacci_data_rom[37]  = 64'd24157817;
    fibonacci_data_rom[38]  = 64'd39088169;
    fibonacci_data_rom[39]  = 64'd63245986;
    fibonacci_data_rom[40]  = 64'd102334155;
    fibonacci_data_rom[41]  = 64'd165580141;
    fibonacci_data_rom[42]  = 64'd267914296;
    fibonacci_data_rom[43]  = 64'd433494437;
    fibonacci_data_rom[44]  = 64'd701408733;
    fibonacci_data_rom[45]  = 64'd1134903170;
    fibonacci_data_rom[46]  = 64'd1836311903;
    fibonacci_data_rom[47]  = 64'd2971215073;
    fibonacci_data_rom[48]  = 64'd4807526976;
    fibonacci_data_rom[49]  = 64'd7778742049;
    fibonacci_data_rom[50]  = 64'd12586269025;
    fibonacci_data_rom[51]  = 64'd20365011074;
    fibonacci_data_rom[52]  = 64'd32951280099;
    fibonacci_data_rom[53]  = 64'd53316291173;
    fibonacci_data_rom[54]  = 64'd86267571272;
    fibonacci_data_rom[55]  = 64'd139583862445;
    fibonacci_data_rom[56]  = 64'd225851433717;
    fibonacci_data_rom[57]  = 64'd365435296162;
    fibonacci_data_rom[58]  = 64'd591286729879;
    fibonacci_data_rom[59]  = 64'd956722026041;
    fibonacci_data_rom[60]  = 64'd1548008755920;
    fibonacci_data_rom[61]  = 64'd2504730781961;
    fibonacci_data_rom[62]  = 64'd4052739537881;
    fibonacci_data_rom[63]  = 64'd6557470319842;
    fibonacci_data_rom[64]  = 64'd10610209857723;
    fibonacci_data_rom[65]  = 64'd17167680177565;
    fibonacci_data_rom[66]  = 64'd27777890035288;
    fibonacci_data_rom[67]  = 64'd44945570212853;
    fibonacci_data_rom[68]  = 64'd72723460248141;
    fibonacci_data_rom[69]  = 64'd117669030460994;
    fibonacci_data_rom[70]  = 64'd190392490709135;
    fibonacci_data_rom[71]  = 64'd308061521170129;
    fibonacci_data_rom[72]  = 64'd498454011879264;
    fibonacci_data_rom[73]  = 64'd806515533049393;
    fibonacci_data_rom[74]  = 64'd1304969544928657;
    fibonacci_data_rom[75]  = 64'd2111485077978050;
    fibonacci_data_rom[76]  = 64'd3416454622906707;
    fibonacci_data_rom[77]  = 64'd5527939700884757;
    fibonacci_data_rom[78]  = 64'd8944394323791464;
    fibonacci_data_rom[79]  = 64'd14472334024676221;
    fibonacci_data_rom[80]  = 64'd23416728348467685;
    fibonacci_data_rom[81]  = 64'd37889062373143906;
    fibonacci_data_rom[82]  = 64'd61305790721611591;
    fibonacci_data_rom[83]  = 64'd99194853094755497;
    fibonacci_data_rom[84]  = 64'd160500643816367088;
    fibonacci_data_rom[85]  = 64'd259695496911122585;
    fibonacci_data_rom[86]  = 64'd420196140727489673;
    fibonacci_data_rom[87]  = 64'd679891637638612258;
    fibonacci_data_rom[88]  = 64'd1100087778366101931;
    fibonacci_data_rom[89]  = 64'd1779979416004714189;
    fibonacci_data_rom[90]  = 64'd2880067194370816120;
    fibonacci_data_rom[91]  = 64'd4660046610375530309;
    fibonacci_data_rom[92]  = 64'd7540113804746346429;
    fibonacci_data_rom[93]  = 64'd12200160415121876738;
    fibonacci_data_rom[94]  = 64'd19740274219868223167;
    fibonacci_data_rom[95]  = 64'd31940434634990099905;
    fibonacci_data_rom[96]  = 64'd51680708854858323072;
    fibonacci_data_rom[97]  = 64'd83621143489848422977;
    fibonacci_data_rom[98]  = 64'd135301852344706746049;
    fibonacci_data_rom[99]  = 64'd218922995834555169026;
    fibonacci_data_rom[100] = 64'd354224848179261915075;
end


/*=============================================================================
 * Signal initialization
 *============================================================================*/
initial begin
    ASI_VALID = 1'b0;
    ASI_DATA = 32'd0;

    #(ResetTime);
    @(posedge CLK);

/*=============================================================================
 * Normal data check
 *============================================================================*/
    $display("%0s(%0d)Normal data check", `__FILE__, `__LINE__);
    for (int i=1;i<94;i++) begin
        wait(ASI_READY);
        ASI_VALID = 1'b1;
        ASI_DATA = i;
        @(posedge CLK);
        ASI_VALID = 1'b0;
        @(posedge CLK);
        wait(ASO_VALID);
        assert (ASO_DATA == fibonacci_data_rom[i])
            $display("%0s(%0d)OK:Assertion ASO_DATA = %0d.", `__FILE__, `__LINE__, fibonacci_data_rom[i]);
        else
            $error("%0s(%0d)ERROR:Assertion ASO_DATA = %0d failed. ASO_DATA = %0d.", `__FILE__, `__LINE__, fibonacci_data_rom[i], ASO_DATA);
        @(posedge CLK);
    end

/*=============================================================================
 * Error check
 *============================================================================*/
    $display("%0s(%0d)Error check", `__FILE__, `__LINE__);
    wait(ASI_READY);
    ASI_VALID = 1'b1;
    ASI_DATA = 0;
    @(posedge CLK);
    ASI_VALID = 1'b0;
    @(posedge CLK);
    wait(ASO_VALID);
    assert (ASO_DATA == 1)
            $display("%0s(%0d)OK:Assertion ASO_DATA = %0d.", `__FILE__, `__LINE__, 1);
        else
            $error("%0s(%0d)ERROR:Assertion ASO_DATA = %0d failed. ASO_DATA = %0d.", `__FILE__, `__LINE__, 1, ASO_DATA);
        @(posedge CLK);

    wait(ASI_READY);
    ASI_VALID = 1'b1;
    ASI_DATA = 101;
    @(posedge CLK);
    ASI_VALID = 1'b0;
    @(posedge CLK);
    wait(ASO_VALID);
    assert (ASO_ERROR == 1'b1)
            $display("%0s(%0d)OK:Assertion ASO_ERROR = %0d.", `__FILE__, `__LINE__, 1'b1);
        else
            $error("%0s(%0d)ERROR:Assertion ASO_ERROR = %0d failed. ASO_ERROR = %0d.", `__FILE__, `__LINE__, 1'b1, ASO_ERROR);
    @(posedge CLK);

    wait(ASI_READY);
    ASI_VALID = 1'b1;
    ASI_DATA = 9'h100;
    @(posedge CLK);
    ASI_VALID = 1'b0;
    @(posedge CLK);
    wait(ASO_VALID);
    assert (ASO_ERROR == 1'b1)
            $display("%0s(%0d)OK:Assertion ASO_ERROR = %0d.", `__FILE__, `__LINE__, 1'b1);
        else
            $error("%0s(%0d)ERROR:Assertion ASO_ERROR = %0d failed. ASO_ERROR = %0d.", `__FILE__, `__LINE__, 1'b1, ASO_ERROR);
    @(posedge CLK);

    $finish;
end

endmodule
// TB_FIB_Q
