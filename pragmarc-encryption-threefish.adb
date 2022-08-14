-- PragmAda Reusable Component (PragmARC)
-- Copyright (C) 2022 by PragmAda Software Engineering.  All rights reserved.
-- Released under the terms of the BSD 3-Clause license; see https://opensource.org/licenses
-- **************************************************************************
--
-- 2022 Feb 01     J. Carter     V1.2--Reorganization for 512- and 1024-bit versions
-- 2021 May 01     J. Carter     V1.1--Adhere to coding standard
-- 2021 Feb 01     J. Carter     V1.0--Initial PragmARC version
--
-- with Ada.Unchecked_Conversion;
with System;

package body PragmARC.Encryption.Threefish with pure is
   use type System.Bit_Order;

   procedure Reverse_Bytes (List : in out Word_As_Bytes);
   -- Reverses the bytes of List

   function Word_From_Bytes (List : in Word_As_Bytes) return Word is
      Local : Word_As_Bytes := List;
   begin -- Word_From_Bytes
      if System.Default_Bit_Order = System.High_Order_First then
         Reverse_Bytes (List => Local);
      end if;

      b1 :
      declare
         proxy_word  :  Word
            with Import, Convention => Ada, Address => Local'Address;
         
      begin
         return proxy_word;
      end b1;
   end Word_From_Bytes;


   function Bytes_From_Word (Value : in Word) return Word_As_Bytes is
      Local :  Word  := Value;
      proxy_word_as_bytes     :  Word_As_Bytes
            with Import, Convention => Ada, Address => Local'Address;
   begin -- Bytes_From_Word
      if System.Default_Bit_Order = System.High_Order_First then
         Reverse_Bytes (List => proxy_word_as_bytes);
      end if;
      
      return proxy_word_as_bytes;
   end Bytes_From_Word;

   procedure Reverse_Bytes (List : in out Word_As_Bytes) is
      procedure Swap (Left : in out Byte; Right : in out Byte);
      -- Swaps Left and Right

      procedure Swap (Left : in out Byte; Right : in out Byte) is
         Temp : constant Byte := Left;
      begin -- Swap
         Left := Right;
         Right := Temp;
      end Swap;

      Last : Natural := List'Last;
   begin -- Reverse_Bytes
      Swap_All : for I in List'First .. Last / 2 loop
         Swap (Left => List (I), Right => List (Last) );
         Last := Last - 1;
      end loop Swap_All;
   end Reverse_Bytes;
end PragmARC.Encryption.Threefish;
