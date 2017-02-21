//bug906

import gmcupkg::*;

module gminstdecode
  (
   output instClassType instClass
   /*blah blah blah*/);

   always_comb begin
      /*AUTORESET*/

      if (ldBitFromIo | stBitToIo) begin
	 instClass.isBool = 1'b1;
	 instClass.iFunc  = IFUNC_BOOL;
	 instClass.sub.bool = 1'b1;
	 instClass.sub2.sub3.bool = 1'b1;
      end
   end

   always_comb begin
      instClass = '{default:0};     // #1 (see below)
      /*AUTORESET*/

      if (ldBitFromIo | stBitToIo) begin
	 instClass.isBool = 1'b1;
	 instClass.iFunc  = IFUNC_BOOL;
      end
   end

   always_comb begin
      instClass.iFunc = IFUNC_ADD;  // #2
      /*AUTORESET*/

      if (ldBitFromIo | stBitToIo) begin
	 instClass.isBool = 1'b1;
	 instClass.iFunc  = IFUNC_BOOL;
      end
   end

   always_comb begin
      instClass.sub = '0;
      instClass.sub2 = '0;
      /*AUTORESET*/

      if (ldBitFromIo | stBitToIo) begin
	 instClass.sub.bool = 1'b1;
	 instClass.sub2.sub3.bool = 1'b1;
	 instClass.sub3.sub4.bool = 1'b1;
      end
   end
endmodule

// Local Variables:
// verilog-auto-reset-widths: unbased
// verilog-typedef-regexp: "Type$"
// End:
