LIBRARY  IEEE; 
USE  IEEE.STD_LOGIC_1164.ALL; 
USE  IEEE.STD_LOGIC_ARITH.ALL; 
USE  IEEE.STD_LOGIC_UNSIGNED.ALL;
 
ENTITY color_rom_vhd  IS 
	PORT( 
	    i_M_US          : IN STD_LOGIC;
	    i_K_US          : IN STD_LOGIC;
	    i_H_US          : IN STD_LOGIC;
	    i_M_BT          : IN STD_LOGIC;
	    i_K_BT          : IN STD_LOGIC;
	    i_H_BT          : IN STD_LOGIC;
	    Z 				: IN STD_LOGIC_VECTOR(1 DOWNTO 0 ) ;
	    T 				: IN STD_LOGIC ; 
	    S 				: IN STD_LOGIC ; 
	    i_pixel_column  : IN STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	    i_pixel_row     : IN STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	    o_red           : OUT STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	    o_green         : OUT STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	    o_blue          : OUT STD_LOGIC_VECTOR( 7 DOWNTO 0 ));
END color_rom_vhd; 

ARCHITECTURE behavioral OF color_rom_vhd  IS 

CONSTANT R_TF_0   : INTEGER := 0;
CONSTANT R_TF_1   : INTEGER := 159;
CONSTANT R_TF_2   : INTEGER := 319;
CONSTANT R_TF_3   : INTEGER := 479;
CONSTANT C_TF1_R  : INTEGER := 79;
CONSTANT C_TF2_R  : INTEGER := 399;
CONSTANT C_TF1_L  : INTEGER := 239;
CONSTANT C_TF2_L  : INTEGER := 559;


SIGNAL M_TF1, M_TF2                 :  STD_LOGIC; 
SIGNAL K_TF1, K_TF2                 :  STD_LOGIC; 
SIGNAL H_TF1, H_TF2                 :  STD_LOGIC; 
SIGNAL grid                         :  STD_LOGIC; 

BEGIN 



PROCESS(i_pixel_row,i_pixel_column, i_M_US  , i_K_US  , i_H_US  , i_M_BT  , i_K_BT  , i_H_BT, M_TF1, M_TF2, K_TF1, K_TF2, H_TF1, H_TF2)
BEGIN

  IF ((i_pixel_row > R_TF_0)  AND (i_pixel_row < R_TF_1)  ) AND ((i_pixel_column >= C_TF1_R)  AND (i_pixel_column < C_TF1_L)  ) THEN M_TF1 <=  '1';
  ELSE  M_TF1 <=  '0';
  END IF;
  
  IF ((i_pixel_row > R_TF_0)  AND (i_pixel_row < R_TF_1)  ) AND ((i_pixel_column >= C_TF2_R)  AND (i_pixel_column < C_TF2_L)  ) THEN M_TF2 <=  '1';
  ELSE M_TF2 <=  '0';
  END IF;
  
  IF ((i_pixel_row > R_TF_1)  AND (i_pixel_row < R_TF_2)  ) AND ((i_pixel_column >= C_TF1_R)  AND (i_pixel_column < C_TF1_L)  ) THEN K_TF1 <=  '1';
  ELSE K_TF1 <=  '0';
  END IF;
  
  IF ((i_pixel_row > R_TF_1)  AND (i_pixel_row < R_TF_2)  ) AND ((i_pixel_column >= C_TF2_R)  AND (i_pixel_column < C_TF2_L)  ) THEN K_TF2 <=  '1';
  ELSE K_TF2 <=  '0';
  END IF;
  
  IF ((i_pixel_row > R_TF_2)  AND (i_pixel_row < R_TF_3)  ) AND ((i_pixel_column >= C_TF1_R)  AND (i_pixel_column < C_TF1_L)  ) THEN H_TF1 <=  '1';
  ELSE H_TF1 <=  '0';
  END IF;
  
  IF ((i_pixel_row > R_TF_2)  AND (i_pixel_row < R_TF_3)  ) AND ((i_pixel_column >= C_TF2_R)  AND (i_pixel_column < C_TF2_L)  ) THEN H_TF2 <=  '1';
  ELSE H_TF2 <=  '0';
  END IF;
  
  IF (i_pixel_column = 5) OR (i_pixel_column = 319) OR (i_pixel_column = 638) THEN grid <=  '1';
  ELSE grid <=  '0';
  END IF;

  IF    (M_TF1 = '1' AND i_M_US= '1' ) THEN  o_red <= X"FF"; o_green <= X"00"; o_blue <= X"00";
  ELSIF (M_TF2 = '1' AND i_M_BT= '1' ) THEN  o_red <= X"FF"; o_green <= X"00"; o_blue <= X"00";
  ELSIF (K_TF1 = '1' AND i_K_US= '1' ) THEN  o_red <= X"FF"; o_green <= X"DD"; o_blue <= X"00";
  ELSIF (K_TF2 = '1' AND i_K_BT= '1' ) THEN  o_red <= X"FF"; o_green <= X"DD"; o_blue <= X"00";
  ELSIF (H_TF1 = '1' AND i_H_US= '1' ) THEN  o_red <= X"00"; o_green <= X"66"; o_blue <= X"00";
  ELSIF (H_TF2 = '1' AND i_H_BT= '1' ) THEN  o_red <= X"00"; o_green <= X"66"; o_blue <= X"00";
  ELSIF (M_TF1 = '1' AND i_M_US= '0' ) THEN  o_red <= X"EE"; o_green <= X"EE"; o_blue <= X"EE";
  ELSIF (M_TF2 = '1' AND i_M_BT= '0' ) THEN  o_red <= X"EE"; o_green <= X"EE"; o_blue <= X"EE";
  ELSIF (K_TF1 = '1' AND i_K_US= '0' ) THEN  o_red <= X"EE"; o_green <= X"EE"; o_blue <= X"EE";
  ELSIF (K_TF2 = '1' AND i_K_BT= '0' ) THEN  o_red <= X"EE"; o_green <= X"EE"; o_blue <= X"EE";
  ELSIF (H_TF1 = '1' AND i_H_US= '0' ) THEN  o_red <= X"EE"; o_green <= X"EE"; o_blue <= X"EE";
  ELSIF (H_TF2 = '1' AND i_H_BT= '0' ) THEN  o_red <= X"EE"; o_green <= X"EE"; o_blue <= X"EE";
  ELSIF (grid = '1')                   THEN  o_red <= X"EE"; o_green <= X"EE"; o_blue <= X"EE";
  ELSE  o_red <= X"00"; o_green <= X"00"; o_blue <= X"00";
  END IF;
  
  
  
END PROCESS;


END behavioral; 